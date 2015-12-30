describe QyWechatApi::Api::User do

  it "#covert_to_open_id" do
    response = $client.user.covert_to_open_id("huaitao")
    expect(response.code).to eq(QyWechatApi::OK_CODE)
  end

end
