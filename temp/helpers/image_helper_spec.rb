require 'spec_helper'

module Poodle
  module ActionView
    describe ImageHelper, type: :helper do

      let(:user) { FactoryGirl.create(:user) }
      let(:user_with_image) { FactoryGirl.create(:user_with_image, name: "Some Name") }

      describe '#namify' do
        it "should return the first letters of the names" do
          expect(helper.namify("Ravi Shankar")).to eq("RS")
          expect(helper.namify("Krishnaprasad")).to eq("K")
          expect(helper.namify("Mohandas Karam Chand Gandhi")).to eq("MK")
        end
      end

      describe '#placeholdit' do
        it "should return placeholdit url" do
          expect(helper.placeholdit()).to eq("http://placehold.it/60x60&text=<No Image>")
          expect(helper.placeholdit(width: 60, height: 40, text: "Not Found")).to eq("http://placehold.it/60x40&text=Not Found")
        end
      end

      describe '#image_url' do
        it "should return placeholder url for user without profile picture" do
          expect(helper.image_url(user, "profile_picture.image.large.url")).to eq("http://placehold.it/60x60&text=<No Image>")
          expect(helper.image_url(user, "profile_picture.image.thumb.url", width: 40, height: 10)).to eq("http://placehold.it/40x10&text=<No Image>")
        end

        it "should return careerwave url for user with profile picture" do
          expect(helper.image_url(user_with_image, "profile_picture.image.large.url")).to eq("/public/uploads/image/profile_picture/1/large_test.jpg")
          expect(helper.image_url(user_with_image, "profile_picture.image.thumb.url")).to eq("/public/uploads/image/profile_picture/1/thumb_test.jpg")
        end
      end

      describe '#display_image' do
        it "should return image tag with placeholder url for user without profile picture" do
          exptected_result = image_tag(placeholdit(), class: "#{user.id}-poodle-thumb-image", width: "100%", height: "auto")
          expect(helper.display_image(user, 'profile_picture.image.large.url')).to eq(exptected_result)

          exptected_result = image_tag(placeholdit(width: 40, height: 50, text: "Hello World"), class: "#{user.id}-poodle-thumb-image", width: "100%", height: "auto")
          expect(helper.display_image(user, 'profile_picture.image.large.url', place_holder: {width: 40, height: 50, text: "Hello World"})).to eq(exptected_result)
        end

        it "should return image tag with careerwave url for user with profile picture" do
          exptected_result = image_tag(user_with_image.profile_picture.image.thumb.url, class: "#{user_with_image.id}-poodle-thumb-image", width: "100%", height: "auto")
          expect(helper.display_image(user_with_image, 'profile_picture.image.thumb.url')).to eq(exptected_result)

          exptected_result = image_tag(user_with_image.profile_picture.image.thumb.url, class: "#{user_with_image.id}-poodle-thumb-image", width: "30px", height: "50px")
          expect(helper.display_image(user_with_image, 'profile_picture.image.thumb.url', width: "30px", height: "50px")).to eq(exptected_result)
        end
      end

      describe '#display_user_image' do
        it "should display placeholder image for user without image" do
          exptected_result = content_tag(:div) do
            content_tag(:div, class: "rounded", style: "width:60px;height:auto") do
              image_tag(placeholdit(text: namify(user.name)), {style: "width:100%;height:auto;cursor:default;", class: "#{user.id}-poodle-thumb-image"})
            end
          end
          expect(helper.display_user_image(user, "profile_picture.image.thumb.url")).to eq(exptected_result)
        end

        it "should display placeholder image with custom width, height and text for user without image" do
          exptected_result = content_tag(:div) do
            content_tag(:div, class: "rounded", style: "width:60px;height:auto") do
              image_tag(placeholdit(width: 100, height: 80, text: "Hello World"), {style: "width:100%;height:auto;cursor:default;", class: "#{user.id}-poodle-thumb-image"})
            end
          end
          expect(helper.display_user_image(user, "profile_picture.image.thumb.url", place_holder: {width: 100, height: 80, text: "Hello World"})).to eq(exptected_result)
        end

        it "should display the profile picture for user with image" do
          exptected_result = content_tag(:div) do
            content_tag(:div, class: "rounded", style: "width:120px;height:auto") do
              image_tag(user_with_image.profile_picture.image.thumb.url, {style: "width:100%;height:auto;cursor:default;", class: "#{user_with_image.id}-poodle-thumb-image"})
            end
          end
          expect(helper.display_user_image(user_with_image, "profile_picture.image.thumb.url", width: "120px")).to eq(exptected_result)
        end

        it "should display the profile picture with popover" do
          exptected_result = content_tag(:div) do
            content_tag(:div, class: "rounded", style: "width:120px;height:auto") do
              image_tag(user_with_image.profile_picture.image.thumb.url, {style: "width:100%;height:auto;cursor:pointer;", class: "#{user_with_image.id}-poodle-thumb-image", "data-toggle" => "popover", "data-placement" => "bottom", title: user_with_image.name, "data-content" => ""})
            end
          end
          expect(helper.display_user_image(user_with_image, "profile_picture.image.thumb.url", width: "120px", popover: true)).to eq(exptected_result)

          exptected_result = content_tag(:div) do
            content_tag(:div, class: "rounded", style: "width:120px;height:auto") do
              image_tag(user_with_image.profile_picture.image.thumb.url, {style: "width:100%;height:auto;cursor:pointer;", class: "#{user_with_image.id}-poodle-thumb-image", "data-toggle" => "popover", "data-placement" => "bottom", title: user_with_image.name, "data-content" => "Senior Engineer"})
            end
          end
          expect(helper.display_user_image(user_with_image, "profile_picture.image.thumb.url", width: "120px", popover: "Senior Engineer")).to eq(exptected_result)
        end
      end

      describe '#edit_image' do
        it "should return an image with edit link" do
          img_tag = helper.display_image(user, "profile_picture.image.thumb.url")
          btn_display = raw(helper.theme_fa_icon('photo') + helper.theme_button_text("Change Image"))
          edit_url = "www.qwinixtech.com"
          exptected_result = link_to(img_tag, edit_url, :remote => true) + link_to(btn_display, edit_url, :class=>"btn btn-default btn-xs mt-10", :remote=>true)
          expect(helper.edit_image(user, "profile_picture.image.thumb.url", edit_url)).to eq(exptected_result)
        end
      end

      describe '#edit_user_image' do
        it "should return an image with edit link" do
          img_tag = helper.display_user_image(user, "profile_picture.image.thumb.url")
          btn_display = raw(helper.theme_fa_icon('photo') + helper.theme_button_text("Change Image"))
          edit_url = "www.qwinixtech.com"
          exptected_result = link_to(img_tag, edit_url, :remote => true) + link_to(btn_display, edit_url, :class=>"btn btn-default btn-xs mt-10", :remote=>true)
          expect(helper.edit_user_image(user, "profile_picture.image.thumb.url", edit_url)).to eq(exptected_result)
        end
      end

      describe '#upload_image_link' do
        it "should return new image path for user with no profile picture" do
          expect(helper.upload_image_link(user, :profile_picture, nil)).to eq("/images/new?image_type=Image%3A%3AProfilePicture&imageable_id=#{user.id}&imageable_type=User")
        end

        it "should return edit image path for user with profile picture" do
          expect(helper.upload_image_link(user_with_image, :profile_picture, nil)).to eq("/images/1/edit?image_type=Image%3A%3AProfilePicture&imageable_id=#{user_with_image.id}&imageable_type=User")
        end

        it "should return edit image path for user with profile picture for custom scope" do
          expect(helper.upload_image_link(user, :profile_picture, :custom)).to eq("/custom/images/new?image_type=Image%3A%3AProfilePicture&imageable_id=#{user.id}&imageable_type=User")
          expect(helper.upload_image_link(user_with_image, :profile_picture, :custom)).to eq("/custom/images/1/edit?image_type=Image%3A%3AProfilePicture&imageable_id=#{user_with_image.id}&imageable_type=User")
        end
      end

    end
  end
end