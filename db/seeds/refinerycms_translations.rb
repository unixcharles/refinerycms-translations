User.find(:all).each do |user|
  user.plugins.create(:name => "translations",
                      :position => (user.plugins.maximum(:position) || -1) +1)
end