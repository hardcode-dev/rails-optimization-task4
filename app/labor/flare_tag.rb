class FlareTag
  FLARES = %w[explainlikeimfive
              ama
              techtalks
              help
              news
              healthydebate
              showdev
              challenge
              anonymous
              hiring
              discuss].freeze

  def initialize(article, except_tag = nil, list_tags = nil)
    @article = article.decorate
    @except_tag = except_tag
    @list_tags = list_tags
  end

  def tag
    flare = FLARES.detect { |f| article.cached_tag_list_array.include?(f) }
    flare && flare != except_tag ? @list_tags[flare] : nil
  end

  def tag_hash
    return unless tag

    { name: tag.name,
      bg_color_hex: tag.bg_color_hex,
      text_color_hex: tag.text_color_hex }
  end

  private

  attr_reader :article, :except_tag
end
