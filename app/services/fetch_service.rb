class FetchService
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

  def fetchNewsApi
  end


  def fetchNyt
  end
end
