class LinksHandler
  include AsyncHandling::Worker

  def perform(url)
    page = repository.find_by_url(url)

    return logger.info("The page with url = #{ url } exists!") if page

    html, status = load_page(url)

    title = html.css('title').text

    create(url: url, title: title, status: status)
  end

  private

  def repository
    return @repository if @repository

    @repository = PageRepository.new
  end

  def load_page(url)
    response = Typhoeus.get(url)

    [Nokogiri::HTML(response.body), response.code]
  end

  def create(params)
    repository.create(params)

    logger.info("Created a page with url = #{ params[:url] }")
  rescue Hanami::Model::UniqueConstraintViolationError => exception
    logger.error(exception.message)
  end
end
