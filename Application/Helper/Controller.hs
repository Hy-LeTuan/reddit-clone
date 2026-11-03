module Application.Helper.Controller where

import IHP.ControllerPrelude
import Generated.Types
import Web.Types

-- Here you can add functions which are available in all your controllers

fetchPostWithRecords :: (?modelContext :: ModelContext) => Id Post -> IO PostWithRecords
fetchPostWithRecords postId = do
    post <- fetch postId
        >>= fetchRelated #userId
        >>= fetchRelated #subredditId
    comments <- fetch post.comments
    let sortedComments = sortOn (Down . (.createdAt)) comments

    commentUsers <- query @User
        |> filterWhereIn (#id, map (get #userId) comments)
        |> fetch

    let roots  = filter (\comment -> isNothing comment.parentId) sortedComments
    let replies = filter (\comment -> not (isNothing comment.parentId)) sortedComments

    return $ PostWithRecords { .. }
