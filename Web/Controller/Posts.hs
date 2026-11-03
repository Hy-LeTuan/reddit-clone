{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Web.Controller.Posts where

import Web.Controller.Prelude
import Web.View.Posts.Index
import Web.View.Posts.New
import Web.View.Posts.Edit
import Web.View.Posts.Show

instance Controller PostsController where
    action PostsAction = do
        ensureIsUser
        posts <- query @Post |> fetch
        render IndexView { .. }

    action NewPostAction = do
        ensureIsUser
        let post = newRecord |> set #userId currentUser.id
        let user = currentUser
        subreddits <- query @Subreddit |> fetch
        render NewView { .. }

    action ShowPostAction { postId } = do
        postWithRecords <- fetchPostWithRecords postId
        let comment = newRecord @Comment
                |> set #userId currentUser.id
                |> set #postId postId
        render ShowView { .. }

    action EditPostAction { postId } = do
        post <- fetch postId
        render EditView { .. }

    action UpdatePostAction { postId } = do
        post <- fetch postId
        post
            |> buildPost
            |> ifValid \case
                Left post -> render EditView { .. }
                Right post -> do
                    post <- post |> updateRecord
                    setSuccessMessage "Post updated"
                    redirectTo (ShowPostAction post.id)

    action UpdateReactionForPostAction { postId, positive } = do
        let userId = currentUserId

        post <- fetch postId :: IO Post

        existingReaction <- query @UserReaction
            |> filterWhere (#userId, userId)
            |> filterWhere (#postId, postId)
            |> fetchOneOrNothing

        -- Calculate how the vote counts should change
        let upvoteDelta = case existingReaction of
                Nothing -> if positive then 1 else 0
                Just reaction ->
                    (if positive then 1 else 0)
                    - (if reaction.upvote then 1 else 0)

        let downvoteDelta = case existingReaction of
                Nothing -> if positive then 0 else 1
                Just reaction ->
                    (if positive then 0 else 1)
                    - (if reaction.upvote then 0 else 1)

        -- Create or update the user's reaction
        case existingReaction of
            Nothing -> do
                newRecord @UserReaction
                    |> set #userId userId
                    |> set #postId postId
                    |> set #upvote positive
                    |> createRecord

            Just reaction -> do
                reaction
                    |> set #upvote positive
                    |> updateRecord

        -- Update post counts
        if upvoteDelta /= 0 || downvoteDelta /= 0
        then do
            post
                |> set #upvotes (post.upvotes + upvoteDelta)
                |> set #downvotes (post.downvotes + downvoteDelta)
                |> updateRecord
            redirectTo (ShowPostAction post.id)
        else
            redirectTo (ShowPostAction post.id)

    action CreatePostAction = do
        let post = newRecord @Post
        post
            |> buildPost
            |> ifValid \case
                Left post -> do
                    let user = currentUser
                    subreddits <- query @Subreddit |> fetch
                    render NewView { .. }
                Right post -> do
                    post <- post |> createRecord
                    setSuccessMessage "Post created"
                    redirectTo PostsAction

    action DeletePostAction { postId } = do
        post <- fetch postId
        deleteRecord post
        setSuccessMessage "Post deleted"
        redirectTo PostsAction

buildPost post = post
    |> fill @'["userId", "title", "body", "upvotes", "downvotes", "subredditId"]
    |> validateField #title nonEmpty
    |> validateField #body nonEmpty
