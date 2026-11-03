module Web.View.Posts.Show where

import Web.View.Prelude

data ShowView = ShowView
  { postWithRecords :: PostWithRecords,
    comment :: Comment
  }

instance View ShowView where
  html ShowView {..} =
    [hsx|
        {breadcrumb}
        <h1>Show Post</h1>
        <div>
            <span>r/ {postWithRecords.post.subredditId.name}</span>
        </div>
        <div>
            <p>@{postWithRecords.post.userId.handle}</p>
            <div>
                <h3>{postWithRecords.post.title}</h3>
                <div>
                    {postWithRecords.post.body}
                </div>
            </div>
            <div class="mt-3 d-flex flex-row justify-content-start align-items-center gap-3">
                <div class="d-flex flex-row justify-content-center align-items-center gap-2">
                    <img class="align-middle" src="/upvote.svg" width="20" height="20" />
                    <div>{postWithRecords.post.upvotes}</div>
                </div>
                <div class="d-flex flex-row justify-content-center align-items-center gap-2">
                    <img class="align-middle" src="/downvote.svg" width="20" height="20" />
                    <div>{postWithRecords.post.downvotes}</div>
                </div>
            </div>
            <div class="mt-3">
                {renderUpvoteForm postWithRecords.post}
            </div>
            <div class="mt-3">
                {renderDownvoteForm postWithRecords.post}
            </div>
            <div class="mt-3">
                {renderInitialComment comment}
            </div>
        </div>
        <hr />
        <div>
            <div class="d-flex flex-column justify-content-start align-items-start gap-3">
                {forEach postWithRecords.roots (renderCommentWithReplies 1 postWithRecords.commentUsers postWithRecords.replies)}
            </div>
        </div>
    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "Posts" PostsAction,
            breadcrumbText "Show Post"
          ]

renderUpvoteForm post = formFor' post (pathTo (UpdateReactionForPostAction post.id True)) [hsx|
    {(hiddenField #userId)}
    {(hiddenField #title)}
    {(hiddenField #body)}
    {(numberField #upvotes)}
    {(hiddenField #downvotes)}
    {(hiddenField #subredditId)}
    {submitButton { label = "Upvote post" }}
|]

renderDownvoteForm post = formFor' post (pathTo (UpdateReactionForPostAction post.id True)) [hsx|
    {(hiddenField #userId)}
    {(hiddenField #title)}
    {(hiddenField #body)}
    {(hiddenField #upvotes)}
    {(numberField #downvotes)}
    {(hiddenField #subredditId)}
    {submitButton { label = "Downvote post" }}
|]

renderInitialComment :: Comment -> Html
renderInitialComment  comment = formFor comment [hsx|
    {(textField #body) { fieldLabel = "", placeholder = "Your thoughts..." } }
    {(hiddenField #userId)}
    {(hiddenField #postId)}
    {(hiddenField #upvotes)}
    {(hiddenField #downvotes)}
    {(hiddenField #parentId)}
    {submitButton { label = "Join the conversation" } }

|]

renderCommentWithReplies :: Int -> [User] -> [Comment] -> Comment -> Html
renderCommentWithReplies iLevel commentUsers allReplies root =
    [hsx|
        {renderComment commentUsers root}
        {if not (length replies == 0)
            then renderCommentWithRepliesAux iLevel commentUsers allReplies replies
            else mempty}
    |]
    where
        replies = filter (\reply -> reply.parentId == Just root.id) allReplies
        renderCommentWithRepliesAux :: Int -> [User] -> [Comment] -> [Comment] -> Html
        renderCommentWithRepliesAux iLevel commentUsers allReplies repliesForRoot =
            [hsx|
            <div class="reply-group">
                <div class={"flex-column justify-content-start align-items-start ms-" <> show (2 * iLevel)}>
                    <div class="reply-indicator">
                        <span class="reply-arrow">↳</span>
                    </div>
                    {forEach repliesForRoot (renderCommentWithReplies (iLevel + 1) commentUsers allReplies)}
                </div>
            </div>
            |]

renderComment :: [User] -> Comment -> Html
renderComment commentUsers comment =
  [hsx|
    <div class="d-flex flex-column justify-content-start align-items-start">
        <div class="d-flex flex-row justify-content-srat align-items-center gap-2">
            <div><b>@{authorDisplay}</b></div>
            <div>•</div>
            <div>{comment.createdAt |> timeAgo}</div>
        </div>
        <div>
            {comment.body}
        </div>
        <div class="d-flex flex-row justify-content-start align-items-center gap-3">
            <div>{comment.upvotes}</div>
            <div>{comment.downvotes}</div>
        </div>
        <div>
            {renderReplyForm replyComment}
        </div>
    </div>
    |]
  where
    authorDisplay =
      commentUsers
        |> find (\user -> user.id == comment.userId)
        |> maybe "" (get #display)
    replyComment =
      newRecord @Comment
        |> set #userId comment.userId
        |> set #postId comment.postId
        |> set #parentId (Just comment.id)

renderReplyForm :: Comment -> Html
renderReplyForm comment =
  formFor
    comment
    [hsx|
    {(hiddenField #upvotes)}
    {(hiddenField #downvotes)}
    {(textField #body) { fieldLabel = "", placeholder = "Reply here" } }
    {(hiddenField #userId)}
    {(hiddenField #postId)}
    {(hiddenField #parentId)}
    {submitButton { label = "Reply"} }
|]
