class PageRepository < Hanami::Repository
  def find_by_url(url)
    pages.where(url: url).limit(1).first
  end
end
