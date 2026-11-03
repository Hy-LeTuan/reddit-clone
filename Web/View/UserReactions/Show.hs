module Web.View.UserReactions.Show where
import Web.View.Prelude

data ShowView = ShowView { userReaction :: UserReaction }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show UserReaction</h1>
        <dl>
            <dt>User Id</dt><dd>{userReaction.userId}</dd>
            <dt>Post Id</dt><dd>{userReaction.postId}</dd>
            <dt>Upvote</dt><dd>{userReaction.upvote}</dd>
        </dl>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "UserReactions" UserReactionsAction
                            , breadcrumbText "Show UserReaction"
                            ]