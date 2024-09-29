require 'net/http'
require 'uri'
require 'json'
require 'dotenv'

module Model
  class Api < ApplicationRecord
    def initialize
      Dotenv.load

      # 環境変数を読み込む
      @client_access_token = ENV['OPENAI_API_KEY']
    end

    # ChatGPT API にリクエストするためのヘッダーを作成
    def headers
      {
        'Authorization' => "Bearer #{@client_access_token}",
        'Content-Type' => 'application/json'
      }
    end

    # 不足した栄養素からレシピを5つ提案するメソッド
    def recommend_recipes(deficiencies)
      prompt = <<-PROMPT
      あなたは栄養士です。次の栄養素が不足しています。
      - 炭水化物: #{deficiencies[:carbohydrates]}グラム
      - タンパク質: #{deficiencies[:proteins]}グラム
      - 脂質: #{deficiencies[:fats]}グラム
      これらの不足を補うためのレシピを5つ提案してください。
      PROMPT

      response = call_chatgpt_api(prompt)
      response['choices'].first['message']['content'].strip.split("\n")
    end

    # 食べた料理名から一食分の栄養素を返すメソッド
    def calculate_nutrients(food_items)
      prompt = <<-PROMPT
      次の料理名から、一食分の炭水化物、タンパク質、脂質の量を計算してください:
      #{food_items}
      PROMPT

      response = call_chatgpt_api(prompt)
      extract_nutrient_data(response['choices'].first['message']['content'])
    end

    private

    # ChatGPT API を呼び出す共通メソッド
    def call_chatgpt_api(prompt)
      uri = URI("https://api.openai.com/v1/chat/completions")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = {
        model: "gpt-3.5-turbo",
        messages: [{ role: 'user', content: prompt }],
        max_tokens: 200
      }.to_json

      response = http.request(request)
      raise "Error fetching response from ChatGPT: #{response.message}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    end

    # APIからのレスポンスから栄養素情報を抽出 これいらないかも？
    def extract_nutrient_data(response_text)
      # レスポンスのテキストを解析して炭水化物、タンパク質、脂質を取得する（仮のパース方法）
      {
        carbohydrates: response_text.match(/炭水化物: (\d+\.?\d*)/)[1].to_f,
        proteins: response_text.match(/タンパク質: (\d+\.?\d*)/)[1].to_f,
        fats: response_text.match(/脂質: (\d+\.?\d*)/)[1].to_f
      }
    end
  end
end