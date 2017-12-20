require 'rails_helper'

RSpec.describe "values/show", type: :view do
  before(:each) do
    @value = assign(:value, Value.create!(
      :value => 2.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2.5/)
  end
end
