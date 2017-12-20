require 'rails_helper'

RSpec.describe "values/edit", type: :view do
  before(:each) do
    @value = assign(:value, Value.create!(
      :value => 1.5
    ))
  end

  it "renders the edit value form" do
    render

    assert_select "form[action=?][method=?]", value_path(@value), "post" do

      assert_select "input[name=?]", "value[value]"
    end
  end
end
