require "rails_helper"

RSpec.describe "NotificationsIndex", type: :request do
  # let_it_be(:dev_account) { create(:user) }
  let_it_be(:user) { create(:user) }
  let_it_be(:user2) { create(:user) }

  before do
    # allow(User).to receive(:dev_account).and_return(dev_account)
  end

  def has_both_names(response_body)
    response_body.include?(CGI.escapeHTML(User.last.name)) && response_body.include?(CGI.escapeHTML(User.second_to_last.name))
  end

  describe "GET /notifications" do
    context "when signed out" do
      it "includes expected words", :aggregate_failures do
        get "/notifications"

        expect(response.body).to include "signup-cue"
        expect(response.body).to include("Notifications")
      end
    end

    context "when signed in" do
      it "does not render the signup cue" do
        sign_in user
        get "/notifications"
        expect(response.body).not_to include "Create your account"
      end
    end

    context "when a user has new follow notifications" do
      before { sign_in user }

      def mock_follow_notifications(amount)
        create_list :user, amount
        follow_instances = User.last(amount).map { |follower| follower.follow(user) }
        follow_instances.each { |follow| Notification.send_new_follower_notification_without_delay(follow) }
      end

      it "renders the proper message for a single notification" do
        mock_follow_notifications(1)
        get "/notifications"
        expect(response.body).to include CGI.escapeHTML(User.last.name)
      end

      it "renders the proper message for two notifications in the same day" do
        mock_follow_notifications(2)
        get "/notifications"
        expect(has_both_names(response.body)).to be true
      end

      it "renders the proper message for three or more notifications in the same day" do
        mock_follow_notifications(4)
        get "/notifications"
        follow_message = "others followed you!"
        expect(response.body).to include follow_message
      end
    end

    context "when a user has new reaction notifications" do
      let_it_be(:article1)                   { create(:article, user_id: user.id) }
      let_it_be(:article2)                   { create(:article, user_id: user.id) }
      let_it_be(:special_characters_article) { create(:article, user_id: user.id, title: "What's Become of Waring") }

      before { sign_in user }

      def mock_heart_reaction_notifications(amount, categories, reactable = article1)
        create_list :user, amount
        reactions = User.last(amount).map do |user|
          create(
            :reaction,
            user_id: user.id,
            reactable_id: reactable.id,
            reactable_type: reactable.class.name,
            category: categories.sample,
          )
        end
        reactions.each { |reaction| Notification.send_reaction_notification_without_delay(reaction, reaction.reactable.user) }
      end

      it "renders the correct user for a single reaction" do
        mock_heart_reaction_notifications(1, %w[like unicorn])
        get "/notifications"
        expect(response.body).to include CGI.escapeHTML(User.last.name)
      end

      it "renders the correct usernames for two or more reactions" do
        mock_heart_reaction_notifications(2, %w[like unicorn])
        get "/notifications"
        expect(has_both_names(response.body)).to be true
      end

      it "renders the proper message for multiple reactions" do
        mock_heart_reaction_notifications(4, %w[unicorn like])
        get "/notifications"
        expect(response.body).to include CGI.escapeHTML("and #{3} others")
      end

      it "does not group notifications that are on the same day but have different reactables" do
        mock_heart_reaction_notifications(1, %w[unicorn like readinglist], article1)
        mock_heart_reaction_notifications(1, %w[unicorn like readinglist], article2)
        get "/notifications"
        notifications = controller.instance_variable_get(:@notifications)
        expect(notifications.count).to eq 2
      end

      it "properly renders reactable titles" do
        mock_heart_reaction_notifications(1, %w[unicorn like readinglist], special_characters_article)
        get "/notifications"
        expect(response.body).to include special_characters_article.title
      end

      it "properly renders reactable titles for multiple reactions" do
        mock_heart_reaction_notifications(4, %w[unicorn like readinglist], special_characters_article)
        get "/notifications"
        expect(response.body).to include special_characters_article.title
      end
    end

    context "when a user has a new comment notification" do
      let_it_be(:article)  { create(:article, user_id: user.id) }
      let_it_be(:comment)  { create(:comment, user_id: user2.id, commentable_id: article.id, commentable_type: "Article") }

      before do
        sign_in user
        Notification.send_new_comment_notifications_without_delay(comment)
        get "/notifications"
      end

      it "includes correct words", :aggregate_failures do
        expect(response.body).to include "commented on"
        expect(response.body).not_to include "As a trusted member"
        expect(response.body).to include article.path
        expect(response.body).to include comment.processed_html
        expect(response.body).not_to include "reaction-button reacted"
      end

      it "renders the reaction as previously reacted if it was reacted on" do
        Reaction.create(user: user, reactable: comment, category: "like")
        get "/notifications"
        expect(response.body).to include "reaction-button reacted"
      end
    end

    context "when a user has a new moderation notification" do
      let(:trusted_user) { create(:user, :trusted) }
      let(:article)  { create(:article, user_id: trusted_user.id) }
      let(:comment)  { create(:comment, user_id: user2.id, commentable_id: article.id, commentable_type: "Article") }

      before do
        sign_in trusted_user
        Notification.send_moderation_notification_without_delay(comment)
        get "/notifications"
      end

      it "includes correct words", :aggregate_failures do
        expect(response.body).to include "As a trusted member"
        expect(response.body).to include article.path
        expect(response.body).to include comment.processed_html
      end
    end

    context "when a user has a new welcome notification" do
      before do
        sign_in user
      end

      it "renders the welcome notification" do
        broadcast = create(:broadcast, :onboarding)
        Notification.send_welcome_notification_without_delay(user.id)
        get "/notifications"
        expect(response.body).to include broadcast.processed_html
      end
    end

    context "when a user has a new badge notification" do
      before do
        sign_in user
        badge = create(:badge)
        badge_achievement = create(:badge_achievement, user: user, badge: badge)
        Notification.send_new_badge_notification_without_delay(badge_achievement)
        get "/notifications"
      end

      it "includes correct words", :aggregate_failures do
        expect(response.body).to include Badge.first.title
        expect(response.body).to include user.badge_achievements.first.rewarding_context_message
        expect(response.body).to include CGI.escapeHTML(Badge.first.description)
        expect(response.body).to include "CHECK YOUR PROFILE"
      end
    end

    context "when a user has a new mention notification" do
      let_it_be(:article) { create(:article, user_id: user.id) }
      let_it_be(:comment) do
        create(
          :comment,
          user_id: user2.id,
          commentable_id: article.id,
          commentable_type: "Article",
          body_markdown: "@#{user.username}",
        )
      end

      before do
        comment
        Mention.create_all_without_delay(comment)
        Notification.send_mention_notification_without_delay(Mention.first)
        sign_in user
        get "/notifications"
      end

      it "includes correct words", :aggregate_failures do
        expect(response.body).to include "mentioned you in a comment"
        expect(response.body).to include comment.processed_html
      end
    end

    context "when a user has a new article notification" do
      let_it_be(:article) { create(:article, user_id: user.id) }

      before do
        user2.follow(user)
        Notification.send_to_followers_without_delay(article, "Published")
        sign_in user2
        get "/notifications"
      end

      it "includes correct attributes", :aggregate_failures do
        expect(response.body).to include "made a new post:"
        expect(response.body).to include article.path
        expect(response.body).to include CGI.escapeHTML(article.user.name)
        expect(response.body).not_to include "reaction-button reacted"
      end

      it "renders the reaction as previously reacted if it was reacted on" do
        Reaction.create(user: user2, reactable: article, category: "like")
        get "/notifications"
        expect(response.body).to include "reaction-button reacted"
      end
    end
  end
end
