User.find(:all).each do |user|
  user.plugins.create(:name => "refinerycms_translations",
                      :position => (user.plugins.maximum(:position) || -1) +1)
end