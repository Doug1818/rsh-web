if Rails.env.development?
  Parse.init application_id: "0I8WCIxThhO07OAIeqKDFwAq0rHRXnHxY5auF6KG", api_key: "QRAhXyWISyBpJmckbiY49a1XtjwlCKhAj2PzMoFR"
else
  Parse.init application_id: "m7UOgUNoihu3JP3Zn9WcShFORaxkoanuTybOWDx8", api_key: "dpQ2WWwn2TXjN5pYbCL5laAZSjdd4dfn48LdFx68"
end
