module Web.Controller.UserReactions where

import Web.Controller.Prelude
import Web.View.UserReactions.Index
import Web.View.UserReactions.New
import Web.View.UserReactions.Edit
import Web.View.UserReactions.Show

instance Controller UserReactionsController where
    action UserReactionsAction = do
        userReactions <- query @UserReaction |> fetch
        render IndexView { .. }

    action NewUserReactionAction = do
        let userReaction = newRecord
        render NewView { .. }

    action ShowUserReactionAction { userReactionId } = do
        userReaction <- fetch userReactionId
        render ShowView { .. }

    action EditUserReactionAction { userReactionId } = do
        userReaction <- fetch userReactionId
        render EditView { .. }

    action UpdateUserReactionAction { userReactionId } = do
        userReaction <- fetch userReactionId
        userReaction
            |> buildUserReaction
            |> ifValid \case
                Left userReaction -> render EditView { .. }
                Right userReaction -> do
                    userReaction <- userReaction |> updateRecord
                    setSuccessMessage "UserReaction updated"
                    redirectTo EditUserReactionAction { .. }

    action CreateUserReactionAction = do
        let userReaction = newRecord @UserReaction
        userReaction
            |> buildUserReaction
            |> ifValid \case
                Left userReaction -> render NewView { .. } 
                Right userReaction -> do
                    userReaction <- userReaction |> createRecord
                    setSuccessMessage "UserReaction created"
                    redirectTo UserReactionsAction

    action DeleteUserReactionAction { userReactionId } = do
        userReaction <- fetch userReactionId
        deleteRecord userReaction
        setSuccessMessage "UserReaction deleted"
        redirectTo UserReactionsAction

buildUserReaction userReaction = userReaction
    |> fill @'["userId", "postId", "upvote"]
