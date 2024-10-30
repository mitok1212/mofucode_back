# app/lib/recipe_api.rb
require 'net/http'
require 'uri'
require 'json'
require 'dotenv/load'

class RecipeApi
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
    これらの不足を補うためのレシピを3つ提案してください。それぞれのレシピのタイトルと詳細な説明を記載してください。
    PROMPT

    response = call_chatgpt_api(prompt)
    response_text = response['choices'].first['message']['content'].strip
    
    # 改行で分割し、タイトルと内容をペアにする
    recipes = response_text.split("\n\n").map do |recipe_block|
      lines = recipe_block.split("\n")
      title = lines[0] # 最初の行をタイトルとして扱う
      content = lines[1..].join("\n") # 残りの行を内容として扱う
      { title: title, content: content }
    end

    recipes
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

  # APIからのレスポンスから栄養素情報を抽出
  def extract_nutrient_data(response_text)
    # レスポンスのテキストを解析して炭水化物、タンパク質、脂質を取得する（仮のパース方法）
    {
      carbohydrates: extract_value(response_text, /炭水化物: (\d+\.?\d*)/),
      proteins: extract_value(response_text, /タンパク質: (\d+\.?\d*)/),
      fats: extract_value(response_text, /脂質: (\d+\.?\d*)/)
    }
  end

  # 値を抽出するためのヘルパーメソッド
  def extract_value(response_text, regex)
    match = response_text.match(regex)
    match ? match[1].to_f : 0.0 # マッチしなかった場合は0.0を返す
  end
end
