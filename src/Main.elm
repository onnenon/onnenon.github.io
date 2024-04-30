module Main exposing (main)

import Browser
import FontAwesome as Icon exposing (Icon)
import FontAwesome.Attributes as Icon
import FontAwesome.Brands as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import Html exposing (a, div, h1, text)
import Html.Attributes exposing (..)


type alias Model =
    { prompt : String, title_text : String }


init : Model
init =
    Model "$" "./onn.sh"


main : Program () Model msg
main =
    Browser.sandbox { init = init, update = update, view = view }


view : Model -> Html.Html msg
view model =
    div
        [ class "flex flex-col min-h-screen dark:bg-prime-black bg-prime-white-bg p-2" ]
        [ Icon.css
        , title model.prompt model.title_text
        , link_icons onnen_links
        ]


update : msg -> Model -> Model
update msg model =
    model


title : String -> String -> Html.Html msg
title prompt title_text =
    div [ class "flex flex-row" ]
        [ h1 [ class title_font_style, class "dark:text-prime-purple text-prime-purple-lt" ] [ text prompt ]
        , h1 [ class title_font_style, class "dark:text-prime-white text-prime-black-txt" ] [ text title_text ]
        , h1 [ class title_font_style, class "text-prime-gray animate-blink" ] [ text "▊" ]
        ]


type alias Link =
    { name : String, url : String, icon : Icon Icon.WithoutId }


onnen_links : List Link
onnen_links =
    [ Link "GitHub" "https://github.com/onnenon" Icon.github
    , Link "LinkedIn" "https://linkedin.com/in/sconnen" Icon.linkedin
    , Link "Email" "mailto:stephen.onnen@gmail.com" Icon.envelope
    ]


link_icons : List Link -> Html.Html msg
link_icons links =
    links
        |> List.map link_icon
        |> div [ class "flex flex-row justify-start" ]


link_icon : Link -> Html.Html msg
link_icon link =
    a
        [ class "flex-shrink text-prime-gray-lt dark:text-prime-gray hover:dark:text-prime-white hover:text-prime-black md:text-4xl text-[7vw] p-[.8em] md:p-[1em]"
        , href link.url
        ]
        [ Icon.view link.icon ]


title_font_style : String
title_font_style =
    "flex font-mono select-none md:text-8xl text-[14vw]"
