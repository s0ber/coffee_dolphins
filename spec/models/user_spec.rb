require 'rails_helper'

describe User do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
    it { is_expected.to allow_value('test@email.com').for(:email) }
    it { is_expected.not_to allow_value('test').for(:email) }
    it { is_expected.not_to allow_value('test @mail.com').for(:email) }

    it { is_expected.to validate_confirmation_of :password }
    it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(128) }
    it { is_expected.to validate_presence_of(:password).on(:create) }
    it { is_expected.not_to validate_presence_of(:password).on(:update) }

    it { is_expected.to validate_presence_of :full_name }
    it { is_expected.to validate_length_of(:full_name).is_at_most(255) }
  end

  describe '#admin?' do
    context 'email is "coffeedolphins@gmail.com"' do
      subject { create(:user, email: 'coffeedolphins@gmail.com') }
      it { is_expected.to be_admin }
    end

    context 'email is not "coffeedolphins@gmail.com"' do
      subject { create(:user) }
      it { is_expected.not_to be_admin }
    end
  end

  describe '#remember_me' do
    it { expect { subject.remember_me = true }.to change(subject, :remember_me).to(true) }
  end

  describe '#male?' do
    context 'gender is set to true' do
      subject { create(:user, gender: true) }
      it { is_expected.to be_male }
    end

    context 'gender is set to false' do
      subject { create(:user, gender: false) }
      it { is_expected.not_to be_male }
    end
  end
end
