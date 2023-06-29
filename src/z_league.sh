#!/bin/bash

access_token=null
api="https://zleague-api.herokuapp.com"
user_agent="okhttp/4.9.2"

function register() {
	# 1 - email: (string): <email>
	# 2 - password: (string): <password>
	curl --request POST \
		--url "$api/v2/account/create" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--data '{
			"email": "'$1'",
			"password": "'$2'",
			"clientType": "MOBILE"
		}'
}

function login() {
	# 1 - username: (string): <username>
	# 2 - password: (string): <password>
	response=$(curl --request POST \
		--url "$api/v2/login" \
		--user-agent "$user_agent" \
		--header "content-type: application/x-www-form-urlencoded" \
		--data "username=$1&password=$2")
	if [ -n $(jq -r ".accessToken" <<< "$response") ]; then
		access_token=$(jq -r ".accessToken" <<< "$response")
		user_id=$(jq -r ".id" <<< "$(get_account_info)")
	fi
	echo $response
}

function get_account_info() {
	curl --request GET \
		--url "$api/v2/account" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_pending_invites() {
	# 1 - page: (integer): <page - default: 1>
	curl --request GET \
		--url "$api/v2/pending-invites?page=${1:-1}" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_unread_notifications_count() {
	curl --request GET \
		--url "$api/v2/account/unopened-notification-count" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_user_info() {
	# 1 - username: (string): <username>
	curl --request GET \
		--url "$api/v2/profile?username=$1" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_previous_teammates() {
	curl --request GET \
		--url "$api/v2/account/previous-teammates" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_user_team_up_profile() {
	# 1 - user_id: (string): <user_id>
	curl --request GET \
		--url "$api/v3/team-up-profile?accountId=$1" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_account_seasons_metadata() {
	curl --request GET \
		--url "$api/v2/account/seasons-metadata" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_account_level_history() {
	curl --request GET \
		--url "$api/v2/account/level-history" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_team_up_browse_filters() {
	curl --request GET \
		--url "$api/v3/team-up-browse-filters" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_profile_banners() {
	curl --request GET \
		--url "$api/v2/profile/banners" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_upcoming_teams() {
	curl --request GET \
		--url "$api/v2/account/upcoming-teams" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_ongoing_teams() {
	curl --request GET \
		--url "$api/v2/account/ongoing-team" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_loot_availability() {
	curl --request GET \
		--url "$api/v2/account/loot/availability" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_games() {
	curl --request GET \
		--url "$api/v2/games" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_feed_posts() {
	# 1 - page_size: (integer): <page_size - default: 20>
	curl --request GET \
		--url "$api/v3/feed/posts/discover?pageSize=${1:-20}" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function update_profile() {
	# 1 - options: (string): <options - about_me, avatar_url, etc>
	# 2 - option_value: (string): <option_value}
	curl --request POST \
		--url "$api/v2/profile" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token" \
		--data '{
			"profileInfo": {
				"'$1'": "'$2'"
			}
		}'
}

function update_account() {
	# 1 - option: (string): <option - first_name, country, etc>
	# 2 - option_value: (string): <option_value}
	curl --request POST \
		--url "$api/v2/account/update" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token" \
		--data '{
			"'$1'": "'$2'"
		}'
}

function get_game_info() {
	# 1 - game: (string): <game>
	curl --request GET \
		--url "$api/v2/games/game-info?game=$1" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_last_loot() {
	curl --request GET \
		--url "$api/v2/account/loot/last" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function claim_loot() {
	curl --request POST \
		--url "$api/v2/account/loot/claim" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_store_items() {
	curl --request GET \
		--url "$api/v2/store/items" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_store_daily_deals() {
	curl --request GET \
		--url "$api/v2/store/daily-deals" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}

function get_active_promo_codes() {
	curl --request GET \
		--url "$api/v2/account/promo-code/active" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $access_token"
}
