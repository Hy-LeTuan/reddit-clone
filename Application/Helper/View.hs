module Application.Helper.View where

import Web.Controller.Prelude
import IHP.ViewPrelude
import IHP.View.Form.Select

-- Here you can add functions which are available in all your views
instance CanSelect Subreddit where
    type SelectValue Subreddit = Id Subreddit
    selectLabel subreddit = "r/ " <> get #name subreddit
    selectValue subreddit = get #id subreddit
