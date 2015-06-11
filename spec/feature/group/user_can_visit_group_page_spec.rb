require 'rails_helper'

feature 'visit group show page' do
  let!(:user)       { User.create(uid: "123",
                                  username: "Jack Nicholson",
                                  email: "crazyman@email.com")}

  let!(:group)      { Group.create(name: "crazies",
                                   description: "Jack Nicholson crazy")}

  let!(:user_group) { UserGroup.create(user_id: user.id, group_id: group.id)}

  let!(:movie)      { Movie.create(title: "Avatar",
                                   imdb_id: "12")}

  let!(:watchlist)  { GroupWatchlist.create(group_id: group.id,
                                            movie_id: movie.id)}


  it 'allows a user in the group to visit the group page' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit user_groups_path(group)

    click_on "Accept Invite"
    click_on "Visit Group"
    expect(current_path).to eq group_path(group)
    within("h3") do
      expect(page).to have_content "#{group.name}"
    end
    expect(page).to have_content "Jack Nicholson crazy"
    expect(page).to have_content "Avatar"
  end

  it 'does not allow a user that is not in the group to visit the group page' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit user_groups_path(group)

    click_on "Decline Invite"
    expect(page).not_to have_content "Visit Group"
    expect(page).not_to have_content group.name
  end
end
