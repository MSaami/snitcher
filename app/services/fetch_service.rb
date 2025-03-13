class FetchService
  def fetch_all
    Category.all().pluck(:id).each do |category_id|
      fetchGuardian(category_id)
      fetchNewsApi(category_id)
      fetchNyt(category_id)
    end

  end

  private

  def fetchGuardian(category_id)
    category = Category.find(category_id)
    url = "http://content.guardianapis.com/search?api-key=11bf90b3-4c5d-43c8-8883-6692c2ffd72c&page-size=50&section=" +  category.name.downcase
    service = HttpClient.new(url)
    response = service.get
    return unless response
    news_items = response.dig("response", "results")
    news_batch = []

    news_items.each do |news_item|
      provider_id = news_item.dig("id")


      news_batch << {
        title: news_item.dig("webTitle"),
        url: news_item.dig("webUrl"),
        source: "guardian",
        category_id: category_id,
        published_at: news_item.dig("webPublicationDate"),
        created_at: Time.now,
        updated_at: Time.now,
        provider_id: provider_id
      }
    end
    News.upsert_all(news_batch, unique_by: [ :provider_id, :source ]) if news_batch.any?
  end

  def fetchNewsApi(category_id)
    category = Category.find(category_id)
    category_name = CategoryMapper.map(:newsapi, category.name.to_sym)

    url = "https://eventregistry.org/api/v1/article/getArticles?apiKey=a079d49b-212d-4fa0-80d0-ad1e82efb9ca&articlesPage=1&dateStart=2025-03-01&lang=eng&categoryUri=" + category_name.to_s
    service = HttpClient.new(url)
    response = service.get
    return unless response
    news_items = response.dig("articles", "results")
    news_batch = []
    news_items.each do |news_item|
      provider_id = news_item.dig("uri")
      news_batch << {
        title: news_item.dig("title"),
        url: news_item.dig("url"),
        source: "newsapi",
        category_id: category_id,
        published_at: news_item.dig("dateTimePub"),
        created_at: Time.now,
        updated_at: Time.now,
        provider_id: provider_id
      }
    end
    News.upsert_all(news_batch, unique_by: [ :provider_id, :source ]) if news_batch.any?
  end


  def fetchNyt(category_id)
    category = Category.find(category_id)
    category_name=  CategoryMapper.map(:nyt, category.name.to_sym)
    url = "https://api.nytimes.com/svc/search/v2/articlesearch.json?&api-key=qvkdA0vbQm1ts4TKgm2GcUDiVuZnNlXG&page=1&fq=pub_date:[2025-02-27T12:07:29%20TO%20*]%20AND%20section_name:(\"#{category_name}\")"
    service = HttpClient.new(url)
    response = service.get
    return unless response
    news_items = response.dig("response", "docs")
    news_batch = []

    news_items.each do |news_item|
      provider_id = news_item.dig("_id")
      news_batch << {
        title: news_item.dig("headline", "main"),
        url: news_item.dig("web_url"),
        source: "nyt",
        category_id: category_id,
        published_at: news_item.dig("pub_date"),
        created_at: Time.now,
        updated_at: Time.now,
        provider_id: provider_id
      }
    end
    News.upsert_all(news_batch, unique_by: [ :provider_id, :source ]) if news_batch.any?
  end
end
