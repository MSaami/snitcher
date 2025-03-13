require 'rails_helper'

RSpec.describe Api::V1::NewsController, type: :controller do
  describe "GET #index" do
  let!(:categories) { create_list(:category, 10) }
  let!(:news) { create_list(:news, 30) }
    context "with default parameters" do
      it "returns success status and the first 10 news items" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "With params" do
      it "returns correct data based on limit and offset" do
        get :index, params: { limit: 5, offset: 5 }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["data"].count).to eq(5)
        expect(JSON.parse(response.body)["data"].first["id"]).to eq(news[news.length - 6].id)
      end

      it "returns correct data based on default limit and offset" do
        get :index
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["data"].count).to eq(10)
        expect(JSON.parse(response.body)["data"].first["id"]).to eq(news[news.length - 1].id)
      end
    end
  end
end
