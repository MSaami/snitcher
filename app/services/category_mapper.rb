module CategoryMapper
  CATEGORIES = [ :Sport, :Technology, :Business, :Art, :Book, :Culture, :Environment, :Film, :Games, :Politics ]


  MAPPINGS = {
    guardian: [ "sport", "technology", "business", "artanddesign", "books", "culture", "environment", "film", "games", "politics" ],
    newsapi: [ "news/Sports", "news/Technology", "news/Business", "news/Arts_and_Entertainment",
             "dmoz/Computers/E-Books", "dmoz/Arts/Movies/Cultures_and_Groups",
             "news/Environment", "dmoz/Arts/Movies/Film_Festivals", "dmoz/Games", "news/Politics" ],
    nyt: [ "Sports", "Technology", "Washington", "Arts", "Books", "Blogs", "Travel", "Movies", "Crosswords/Games", "Opinion" ]
  }

  def self.map(source, category_name)
    if MAPPINGS[source].nil?
      raise "No mapping for source #{source}"
    end

    if CategoryMapper::CATEGORIES.index(category_name).nil?
      raise "No mapping for category #{category_name}"
    end

    index = CATEGORIES.index(category_name)

    if MAPPINGS[source][index].nil?
      raise "No mapping for category #{category_name} in source #{source}"
    end
    MAPPINGS[source][index]
  end
end
