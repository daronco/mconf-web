# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

require "spec_helper"

describe Profile do

  describe "abilities", :abilities => true do
    set_custom_ability_actions([:update_logo])
    subject { ability }
    let(:ability) { Abilities.ability_for(user) }
    let(:target) { FactoryGirl.create(:user).profile }

    # commons specs run for several types of users
    shared_examples_for "a profile's ability" do |visibilities|
      context "given the profile visibility is" do
        visibilities.each do |visibility|
          it "'#{visibility}'" do
            target.visibility = Profile::VISIBILITY.index(visibility)
            should_not be_able_to_do_anything_to(target).except(:read)
          end
        end
        Profile::VISIBILITY.each do |visibility|
          unless visibilities.include?(visibility)
            it "'#{visibility}'" do
              target.visibility = Profile::VISIBILITY.index(visibility)
              should_not be_able_to_do_anything_to(target)
            end
          end
        end
      end
    end

    context "when is the profile owner" do
      let(:user) { target.user }
      context "regardless of the profile's visibility" do
        Profile::VISIBILITY.each do |visibility|
          before { target.visibility = Profile::VISIBILITY.index(visibility) }
          it { should be_able_to(:read, target) }
          it { should be_able_to(:update, target) }
          it { should be_able_to(:update_logo, target) }
        end
      end
    end

    context "when is a superuser" do
      let(:user) { FactoryGirl.create(:superuser) }
      context "regardless of the profile's visibility" do
        Profile::VISIBILITY.each do |visibility|
          before { target.visibility = Profile::VISIBILITY.index(visibility) }
          it { should be_able_to(:manage, target) }
        end
      end
    end

    context "when is an anonymous user" do
      let(:user) { User.new }
      it_should_behave_like "a profile's ability", [:everybody]
    end

    context "when is a website member (but not a fellow)" do
      let(:user) { FactoryGirl.create(:user) }
      it_should_behave_like "a profile's ability", [:everybody, :members]
    end

    context "when is a public fellow user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:space) { FactoryGirl.create(:public_space) }
      before {
        space.add_member!(target.user)
        space.add_member!(user)
      }
      it_should_behave_like "a profile's ability",
        [:everybody, :members, :public_fellows]
    end

    context "when is a private fellow user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:space) { FactoryGirl.create(:private_space) }
      before {
        space.add_member!(target.user)
        space.add_member!(user)
      }
      it_should_behave_like "a profile's ability",
        [:everybody, :members, :public_fellows, :private_fellows]
    end
  end

end
