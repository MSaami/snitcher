class Api::V1::NewsController < ApplicationController
  MAX_PER_PAGE = 50


  def index
    offset = params.fetch(:offset, 0)
    limit = params[:limit] ? [ params[:limit].to_i, MAX_PER_PAGE ].min : 10

    news = News.where(filter_params).offset(offset).limit(limit).order(id: :desc)
    render json: { data: news }
  end

  private
  def filter_params
    params.permit(:source, :category_id)
  end
end
