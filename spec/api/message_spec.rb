require "spec_helper"
describe QyWechatApi::Api::Message do
  let(:text_message) do
    "text message"
  end

  let(:image_path) do
    "#{File.dirname(__FILE__)}/medias/ruby-logo.jpg"
  end

  let(:image_file) do
    File.new(image_path)
  end

  it "#send_text_message" do
    response = $client.message.send_text("@all", "@all", "@all", 1, text_message)
    expect(response.code).to eq(QyWechatApi::OK_CODE)
  end

  it "#send_image_message" do
    response = $client.media.upload(image_path, "image").result
    response = $client.message.send_image("@all", "@all", "@all", 1, response["media_id"])
    expect(response.code).to eq(QyWechatApi::OK_CODE)
  end


  it "#send_news" do
    articles = [{
                  "title" => "Happy Day",
                  "description" => "Is Really A Happy Day",
                  "url"   => "http://www.baidu.com",
                  "picurl" => "http://www.baidu.com/img/bdlogo.gif"
                },
                {
                  "title" => "Happy Day",
                  "description" => "Is Really A Happy Day",
                  "url"  => "http://www.baidu.com",
                  "picurl"=> "http://www.baidu.com/img/bdlogo.gif"
                }]
    response = $client.message.send_news("@all", "@all", "@all", 1, articles)
    expect(response.code).to eq(QyWechatApi::OK_CODE)
  end

  it "#send_file" do
    response = $client.media.upload(image_path, "image").result
    response = $client.message.send_file("@all", "@all", "@all", 1, response["media_id"])
    expect(response.code).to eq(QyWechatApi::OK_CODE)
  end

end
