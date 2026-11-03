module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

-- Controller Imports
import Web.Controller.UserReactions
import Web.Controller.UserReactions
import Web.Controller.Comments
import Web.Controller.Users
import Web.Controller.Subreddits
import Web.Controller.Posts
import Web.Controller.Static
import Web.Controller.Sessions

instance FrontController WebApplication where
    controllers =
        [ startPage WelcomeAction
        , parseRoute @SessionsController
        -- Generator Marker
        , parseRoute @UserReactionsController
        , parseRoute @UserReactionsController
        , parseRoute @CommentsController
        , parseRoute @UsersController
        , parseRoute @SubredditsController
        , parseRoute @PostsController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
