module Web.View.Posts.Index where
import Web.View.Prelude

data IndexView = IndexView { posts :: [Post] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewPostAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>User Id</th>
                        <th>Title</th>
                        <th>Body</th>
                        <th>Upvotes</th>
                        <th>Downvotes</th>
                        <th>Subreddit Id</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach posts renderPost}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                ]

renderPost :: Post -> Html
renderPost post = [hsx|
    <tr>
        <td>{post.userId}</td>
        <td>{post.title}</td>
        <td>{post.body}</td>
        <td>{post.upvotes}</td>
        <td>{post.downvotes}</td>
        <td>{post.subredditId}</td>
        <td><a href={ShowPostAction post.id}>Show</a></td>
        <td><a href={EditPostAction post.id} class="text-muted">Edit</a></td>
        <td><a href={DeletePostAction post.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]