ModelStubbing.define_models :validation => false, :callbacks => false do
  time 2007, 6, 15
  
  model User do
    stub :login => 'normal-user',
      :salt => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
      :created_at => current_time - 5.days, :remember_token => 'foo-bar', :remember_token_expires_at => current_time + 5.days,
      :email => 'normal-user@example.com'
  end
  
  model Conduit do
    stub :key => "rabble", :private => false, :url => "http://bymatthew.com/"
  end

end