require 'rails_helper'

RSpec.describe "values/new", type: :view do
  before(:each) do
    assign(:value, Value.new(
      :value => 1.5
    ))
  end

  it "renders new value form" do
    render

    assert_select "form[action=?][method=?]", values_path, "post" do

      assert_select "input[name=?]", "value[value]"
    end
  end
end
