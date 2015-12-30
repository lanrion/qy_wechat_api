describe QyWechatApi::Api::Department do

  it "#list department" do
    response = $client.department.list
    expect(response.code).to eq(QyWechatApi::OK_CODE)
  end

end
