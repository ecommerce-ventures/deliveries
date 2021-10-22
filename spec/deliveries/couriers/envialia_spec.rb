require 'deliveries/support/envialia_stubs'

RSpec.describe "Envialia" do
  it ".login" do
    register_envialia_login_stubs

    Deliveries.courier(:envialia).login
  end
end
