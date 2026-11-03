module Web.View.UserReactions.Index where
import Web.View.Prelude

data IndexView = IndexView { userReactions :: [UserReaction] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewUserReactionAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>User Id</th>
                        <th>Post Id</th>
                        <th>Upvote</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach userReactions renderUserReaction}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "UserReactions" UserReactionsAction
                ]

renderUserReaction :: UserReaction -> Html
renderUserReaction userReaction = [hsx|
    <tr>
        <td>{userReaction.userId}</td>
        <td>{userReaction.postId}</td>
        <td>{userReaction.upvote}</td>
        <td><a href={ShowUserReactionAction userReaction.id}>Show</a></td>
        <td><a href={EditUserReactionAction userReaction.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteUserReactionAction userReaction.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]