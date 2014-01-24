if Rails.env.development?
  Parse.init application_id: "0I8WCIxThhO07OAIeqKDFwAq0rHRXnHxY5auF6KG", api_key: "RaBSqZgrwrNeDvvFN6vX63c9Ha02WDkGuwuzd24V" # dev
  # Parse.init application_id: "m7UOgUNoihu3JP3Zn9WcShFORaxkoanuTybOWDx8", api_key: "sHlZbb3wUgFoVXYPaCmRirwWx0LE2HNO3J4twNwK" # production
else
	# Parse.init application_id: "0I8WCIxThhO07OAIeqKDFwAq0rHRXnHxY5auF6KG", api_key: "RaBSqZgrwrNeDvvFN6vX63c9Ha02WDkGuwuzd24V" # dev
	# Figure out better solution to line up testflight + heroku with development but appstore + heroku with production
  Parse.init application_id: "m7UOgUNoihu3JP3Zn9WcShFORaxkoanuTybOWDx8", api_key: "sHlZbb3wUgFoVXYPaCmRirwWx0LE2HNO3J4twNwK" # production
end
