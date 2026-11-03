module Web.View.Comments.Edit where
import Web.View.Prelude

data EditView = EditView { comment :: Comment }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Comment</h1>
        {renderForm comment}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Comments" CommentsAction
                , breadcrumbText "Edit Comment"
                ]

renderForm :: Comment -> Html
renderForm comment = formFor comment [hsx|
    {- userId needs to be a selectField -}
        {(textField #userId)}
    {- postId needs to be a selectField -}
        {(textField #postId)}
    {(numberField #upvotes)}
    {(numberField #downvotes)}
    {- parentId needs to be a selectField -}
        {(textField #parentId)}
    {(textField #body)}
    {submitButton}

|]
