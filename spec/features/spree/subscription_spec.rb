require 'spec_helper'

feature 'Chimpy', :js do
  background do
    visit '/signup'
  end

  scenario 'guest subscription deface data-hook confirmation' do
    page.find('#spree-header')
  end

  scenario 'user subscription with opt_in' do
    subscribe!
    expect(current_path).to eq spree.root_path
    expect(page).to have_selector '.alert-notice', text: 'Welcome! You have signed up successfully.'
    expect(Spree::User.count).to be(1)
    expect(Spree::User.first.subscribed).to be_truthy
  end

  scenario 'user subscription with opt_out' do
    skip 'does this refer to the double opt_in/out?'
    subscribe!

    expect(current_path).to eq spree.root_path
    expect(page).to have_selector '.notice', text: 'Welcome! You have signed up successfully.'
    expect(Spree::User.count).to be(1)
    expect(Spree::User.first.subscribed).to be_falsey
  end

  def subscribe!
    expect(page).to have_text 'Sign me up for email updates on special promotions, latest products, featured news and more!'

    fill_in 'Email', with: FFaker::Internet.email
    fill_in 'Password', with: 'secret123'
    fill_in 'Password Confirmation', with: 'secret123'

    check 'Sign me up for email updates on special promotions, latest products, featured news and more!'

    expect(page.has_checked_field?('spree_user_subscribed')).to be_truthy
    click_button 'Create'
  end
end
