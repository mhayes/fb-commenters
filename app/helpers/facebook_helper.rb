module FacebookHelper
  def facebook_login_button(size='large')
    content_tag("fb:login-button", nil , {
      :perms => 'user_likes, friends_likes, user_interests, user_groups, user_activities, read_stream',
      :id => "fb_login",
      :autologoutlink => 'true',
      :size => size,
      :onlogin => 'location = "/"'})
  end
end
