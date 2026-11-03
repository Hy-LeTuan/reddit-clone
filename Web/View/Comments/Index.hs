module Web.View.Comments.Index where
import Web.View.Prelude

data IndexView = IndexView { comments :: [Comment] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>All comments</h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Upvotes</th>
                        <th>Downvotes</th>
                        <th>Body</th>
                        <th>User Id</th>
                        <th>Post Id</th>
                        <th>Parent Id</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach comments renderComment}</tbody>
            </table>

        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Comments" CommentsAction
                ]

renderComment :: Comment -> Html
renderComment comment = [hsx|
    <tr>
        <td>{comment.upvotes}</td>
        <td>{comment.downvotes}</td>
        <td>{comment.body}</td>
        <td>{comment.userId}</td>
        <td>{comment.postId}</td>
        <td>{comment.parentId}</td>
        <td><a href={ShowCommentAction comment.id}>Show</a></td>
        <td><a href={EditCommentAction comment.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteCommentAction comment.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
