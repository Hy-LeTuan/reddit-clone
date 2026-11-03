module Web.Controller.Subreddits where

import Web.Controller.Prelude
import Web.View.Subreddits.Index
import Web.View.Subreddits.New
import Web.View.Subreddits.Edit
import Web.View.Subreddits.Show

instance Controller SubredditsController where
    action SubredditsAction = do
        subreddits <- query @Subreddit |> fetch
        render IndexView { .. }

    action NewSubredditAction = do
        let subreddit = newRecord
        render NewView { .. }

    action ShowSubredditAction { subredditId } = do
        subreddit <- fetch subredditId
        render ShowView { .. }

    action EditSubredditAction { subredditId } = do
        subreddit <- fetch subredditId
        render EditView { .. }

    action UpdateSubredditAction { subredditId } = do
        subreddit <- fetch subredditId
        subreddit
            |> buildSubreddit
            |> ifValid \case
                Left subreddit -> render EditView { .. }
                Right subreddit -> do
                    subreddit <- subreddit |> updateRecord
                    setSuccessMessage "Subreddit updated"
                    redirectTo EditSubredditAction { .. }

    action CreateSubredditAction = do
        let subreddit = newRecord @Subreddit
        subreddit
            |> buildSubreddit
            |> ifValid \case
                Left subreddit -> render NewView { .. } 
                Right subreddit -> do
                    subreddit <- subreddit |> createRecord
                    setSuccessMessage "Subreddit created"
                    redirectTo SubredditsAction

    action DeleteSubredditAction { subredditId } = do
        subreddit <- fetch subredditId
        deleteRecord subreddit
        setSuccessMessage "Subreddit deleted"
        redirectTo SubredditsAction

buildSubreddit subreddit = subreddit
    |> fill @'["name", "description"]
    |> validateField #name nonEmpty
    |> validateField #description nonEmpty
