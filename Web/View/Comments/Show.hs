module Web.View.Comments.Show where
import Web.View.Prelude

data ShowView = ShowView { comment :: Comment }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Comment</h1>
        <dl>
            <dt>User Id</dt><dd>{comment.userId}</dd>
            <dt>Post Id</dt><dd>{comment.postId}</dd>
            <dt>Upvotes</dt><dd>{comment.upvotes}</dd>
            <dt>Downvotes</dt><dd>{comment.downvotes}</dd>
            <dt>Parent Id</dt><dd>{comment.parentId}</dd>
        </dl>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Comments" CommentsAction
                            , breadcrumbText "Show Comment"
                            ]