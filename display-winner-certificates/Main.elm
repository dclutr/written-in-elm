module Main exposing (main)

import Array exposing (fromList, get)
import Browser
import Html exposing (Html, button, div, text, textarea)
import Html.Attributes exposing (cols, rows, spellcheck, value)
import Html.Events exposing (onClick, onInput)
import Svg exposing (Svg, circle, ellipse, image, line, rect, svg, text, text_, tspan)
import Svg.Attributes exposing (dominantBaseline, dx, dy, fontFamily, fontSize, fontStyle, fontWeight, height, style, textAnchor, viewBox, width, x, xlinkHref, y)
import Svg.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { editorText : String
    , editorMode : Bool
    , page : Int
    }


init : Model
init =
    Model
        (""
            ++ "Meeting\n"
            ++ "  196\n"
            ++ "\n"
            ++ "Date and Venue\n"
            ++ "  23 Apr 2021, Pune, India\n"
            ++ "\n"
            ++ "Club\n"
            ++ "  A Certain\n"
            ++ "  Toastmasters Club\n"
            ++ "\n"
            ++ "Signature\n"
            ++ "  Albus Dumbledore\n"
            ++ "  Club President\n"
            ++ "  AC TMC\n"
            ++ "\n"
            ++ "Speaker\n"
            ++ "  Albus Dumbledore\n"
            ++ "\n"
            ++ "Table Topics Speaker\n"
            ++ "  Fred Weasley\n"
            ++ "  George Weasley\n"
            ++ "\n"
            ++ "Evaluator\n"
            ++ "  Severus Snape\n"
            ++ "\n"
            ++ "Roleplayer with Shorter Stage Time\n"
            ++ "  Lily Potter\n"
            ++ "\n"
            ++ "Roleplayer with Longer Stage Time\n"
            ++ "  Lord Voldemort\n"
            ++ "\n"
        )
        True
        0



-- UPDATE


stringIsNotEmpty : String -> Bool
stringIsNotEmpty text =
    not
        (String.isEmpty
            (String.trim
                text
            )
        )



--  stringIsNotEmpty "                  " == false
--  stringIsNotEmpty "  George Weasley  " == true


listOfSections : String -> List String
listOfSections text =
    List.filter
        stringIsNotEmpty
        (String.split
            "\n\n"
            (String.join
                "\n"
                (List.map
                    String.trim
                    (String.lines
                        text
                    )
                )
            )
        )



--  listOfSections
--      ( "Heading 1\n"
--      ++"  Some Text 1\n"
--      ++"\n"
--      ++"Heading 2\n"
--      ++"  Some Text 2\n"
--      ++"\n"
--      ) ==
--
--  [ "Heading 1\nSome Text 1"
--  , "Heading 2\nSome Text 2"
--  ]


isWinnerSection : String -> Bool
isWinnerSection section =
    not
        (False
            || String.startsWith "Meeting" section
            || String.startsWith "Date and Venue" section
            || String.startsWith "Club" section
            || String.startsWith "Signature" section
        )



--  isWinnerSection "Meeting\n100" == false
--  isWinnerSection "Speaker\nAlbus Dumbledore" == true


winnerSectionToListOfTuples : String -> List ( String, String )
winnerSectionToListOfTuples winnerSection =
    case
        List.head
            (String.lines
                winnerSection
            )
    of
        Nothing ->
            []

        Just winnerRole ->
            case
                List.drop
                    1
                    (String.lines
                        winnerSection
                    )
            of
                listOfNames ->
                    List.map2
                        Tuple.pair
                        (List.repeat
                            (List.length
                                listOfNames
                            )
                            winnerRole
                        )
                        listOfNames



--  winnerSectionToListOfTuples
--      "Table Topics Speaker\n George\n Fred" ==
--
--  [ ("Table Topics Speaker", "George")
--  , ("Table Topics Speaker", "Fred")
--  ]


listOfWinners : String -> List ( String, String )
listOfWinners editorText =
    List.concat
        (List.map
            winnerSectionToListOfTuples
            (List.filter
                isWinnerSection
                (listOfSections
                    editorText
                )
            )
        )



--  listOfWinners
--      "Meeting\n 100\n Speaker\n Albus\n "Table Topics Speaker\n George\n Fred" ==
--
--  [ ("Speaker", "Albus")
--  , ("Table Topics Speaker", "George")
--  , ("Table Topics Speaker", "Fred")
--  ]


getMaxPage : String -> Int
getMaxPage editorText =
    2
        * List.length
            (listOfWinners
                editorText
            )



--  getMaxPage
--      "Meeting\n 100\n Speaker\n Albus\n Evaluator\n Snape\n" ==
--
--  4 ( from 0 to 4 )


type Msg
    = UpdateTextAndPage String
    | OpenEditor
    | NextPage
    | PreviousPage


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateTextAndPage text ->
            { model
                | editorText =
                    text
                , page =
                    min
                        model.page
                        (getMaxPage text)
            }

        OpenEditor ->
            { model | editorMode = not model.editorMode }

        NextPage ->
            { model | page = model.page + 1 }

        PreviousPage ->
            { model | page = model.page - 1 }



-- VIEW
-- [colors]


blue : String
blue =
    "#004165"


blue2 : String
blue2 =
    "#D4DEEE"


blue3 : String
blue3 =
    "#F2F2F2"


red : String
red =
    "#772432"


grey : String
grey =
    "#969FA7"


white : String
white =
    "#FFFFFF"


black : String
black =
    "#000000"



-- [date and number helper functions]


day : String -> String
day dateAndVenue =
    case List.head (String.words dateAndVenue) of
        Nothing ->
            ""

        Just someDay ->
            someDay



--  day
--      "1 Jan 2000, Pune, India" ==
--
--  "1"


month : String -> String
month dateAndVenue =
    case List.head (List.drop 1 (String.words dateAndVenue)) of
        Nothing ->
            ""

        Just someMonth ->
            case String.toUpper (String.slice 0 3 someMonth) of
                "JAN" ->
                    "January"

                "FEB" ->
                    "February"

                "MAR" ->
                    "March"

                "APR" ->
                    "April"

                "MAY" ->
                    "May"

                "JUN" ->
                    "June"

                "JUL" ->
                    "July"

                "AUG" ->
                    "August"

                "SEP" ->
                    "September"

                "OCT" ->
                    "October"

                "NOV" ->
                    "November"

                "DEC" ->
                    "December"

                _ ->
                    ""



--  month
--      "1 Jan 2000, Pune, India" ==
--
--  "January"


yearAndVenue : String -> String
yearAndVenue dateAndVenue =
    String.join " " (List.drop 2 (String.words dateAndVenue))



--  yearAndVenue
--      "1 Jan 2000, Pune, India"
--
--  "2000, Pune, India\n"


numberPostfix : String -> String
numberPostfix num =
    case String.length num of
        1 ->
            if num == "1" then
                "st"

            else if num == "2" then
                "nd"

            else if num == "3" then
                "rd"

            else
                "th"

        _ ->
            if String.startsWith "1" (String.slice -3 -1 (num ++ " ")) then
                "th"

            else if String.endsWith "1" num then
                "st"

            else if String.endsWith "2" num then
                "nd"

            else if String.endsWith "3" num then
                "rd"

            else
                "th"



--  numberPostfix
--      "111" ==
--
--  "th"
--  numberPostfix
--      "222" ==
--
--  "nd"
--  numberPostfix
--      "333" ==
--
--  "rd"
--  numberPostfix
--      "321" ==
--
--  "st"


button1 : String -> String -> Msg -> String -> String -> String -> Svg Msg
button1 left top action color size buttonText =
    text_
        [ x left
        , y top
        , fontSize size
        , style ("fill:" ++ color)
        , dominantBaseline "middle"
        , textAnchor "middle"
        , Svg.Events.onClick action
        ]
        [ Svg.text buttonText ]


rect1 : String -> String -> String -> String -> String -> Svg Msg
rect1 left top right bottom color =
    rect
        [ x left
        , y top
        , width right
        , height bottom
        , style ("fill:" ++ color)
        ]
        []


text_1 : String -> String -> String -> String -> String -> Svg Msg
text_1 left top size color text =
    text_
        [ x left
        , y top
        , fontSize size
        , fontFamily "Arial"
        , style ("fill:" ++ color)
        , dominantBaseline "middle"
        , textAnchor "middle"
        ]
        [ Svg.text text ]


text_bold_1 : String -> String -> String -> String -> String -> Svg Msg
text_bold_1 left top size color text =
    text_
        [ x left
        , y top
        , fontSize size
        , fontFamily "Arial"
        , fontWeight "bold"
        , style ("fill:" ++ color)
        , dominantBaseline "middle"
        , textAnchor "middle"
        ]
        [ Svg.text (String.toUpper text) ]


text_italic_1 : String -> String -> String -> String -> String -> Svg Msg
text_italic_1 left top size color text =
    text_
        [ x left
        , y top
        , fontSize size
        , fontFamily "Arial"
        , fontStyle "italic"
        , style ("fill:" ++ color)
        , dominantBaseline "middle"
        , textAnchor "middle"
        ]
        [ Svg.text text ]


text_date_1 : String -> String -> String -> String -> String -> Svg Msg
text_date_1 left top size color dateText =
    text_
        [ x left
        , y top
        , fontSize size
        , fontFamily "Arial"
        , style ("fill:" ++ color)
        , dominantBaseline "middle"
        , textAnchor "middle"
        ]
        [ tspan [] [ Svg.text (day dateText) ]
        , tspan [ dy "-10" ] [ Svg.text (numberPostfix (day dateText)) ]
        , tspan [ dy "10" ] [ Svg.text (" " ++ month dateText) ]
        , tspan [] [ Svg.text (" " ++ yearAndVenue dateText) ]
        ]


text_date_upper_case_1 : String -> String -> String -> String -> String -> Svg Msg
text_date_upper_case_1 left top size color dateText =
    text_
        [ x left
        , y top
        , fontSize size
        , fontFamily "Arial"
        , style ("fill:" ++ color)
        , dominantBaseline "middle"
        , textAnchor "middle"
        ]
        [ tspan [] [ Svg.text (day dateText) ]
        , tspan [ dy "-10" ] [ Svg.text (numberPostfix (day dateText)) ]
        , tspan [ dy "10" ] [ Svg.text (String.toUpper (" " ++ month dateText)) ]
        , tspan [] [ Svg.text (" " ++ yearAndVenue dateText) ]
        ]


text_error_1 : String -> String -> String -> Svg Msg
text_error_1 left top text =
    text_
        [ x left
        , y top
        , style ("fill:" ++ red)
        ]
        [ Svg.text text ]



-- [page elements]


buttons : Int -> Int -> List (Svg Msg)
buttons page maxPage =
    List.concat
        [ if page > 0 then
            [ button1 "8%" "45%" PreviousPage blue "60" "<" ]

          else
            []
        , if page < maxPage then
            [ button1 "92%" "45%" NextPage blue "60" ">" ]

          else
            []
        ]


rectangles : List (Svg Msg)
rectangles =
    [ rect1 "0" "0" "2100" "1200" blue3
    , rect1 "315" "0" "1470" "1060" white
    , rect1 "384" "60" "440" "18" blue
    , rect1 "830" "60" "440" "18" red
    , rect1 "1276" "60" "440" "18" grey
    , rect1 "384" "330" "1332" "465" blue2
    , rect1 "384" "795" "1332" "200" blue3
    ]


tmLogoAndWordMark : List (Svg Msg)
tmLogoAndWordMark =
    [ image
        [ x "458"
        , y "10%"
        , width "160"
        , xlinkHref
            ("https://toastmasterscdn.azureedge.net"
                ++ "/medias/images/brand-items/"
                ++ "logos-and-wordmarks/"
                ++ "toastmasters-logo-color-png.png"
            )
        , dominantBaseline "middle"
        ]
        []
    , text_bold_1 "537.2" "23%" "15" red "WHERE LEADERS ARE MADE"
    ]


textClubName : String -> List (Svg Msg)
textClubName club =
    case String.lines club of
        [ firstLine, secondLine ] ->
            [ text_1 "50%" "15%" "60" black (String.toUpper firstLine)
            , text_1 "50%" "20%" "60" black (String.toUpper secondLine)
            ]

        [ firstLine ] ->
            [ text_1 "50%" "17.5%" "60" black (String.toUpper firstLine) ]

        _ ->
            [ text_error_1 "50%" "15%" "[Ensure the club name is 1-2 lines]" ]


textStartPage : String -> String -> List (Svg Msg)
textStartPage meeting dateAndVenue =
    [ text_1 "50%" "45%" "78" blue "AWARDS"
    , text_1 "50%" "51%" "48" red ("Chapter #" ++ meeting)
    , text_date_1 "50%" "56%" "42" red dateAndVenue
    ]


textAnticipationPage : ( String, String ) -> List (Svg Msg)
textAnticipationPage ( winnerRole, winnerName ) =
    [ text_1 "50%" "47%" "78" blue "BEST"
    , text_1 "50%" "52%" "50" red (String.toUpper winnerRole)
    ]


textResultPage : ( String, String ) -> String -> String -> List (Svg Msg)
textResultPage ( winnerRole, winnerName ) meeting dateAndVenue =
    [ text_1
        "50%"
        "32%"
        "44"
        red
        "RECOGNIZES"
    , text_bold_1
        "50%"
        "37%"
        "44"
        blue
        winnerName
    , text_1
        "50%"
        "42%"
        "44"
        red
        "FOR BEING THE"
    , text_bold_1
        "50%"
        "47%"
        "44"
        blue
        ("BEST " ++ String.toUpper winnerRole)
    , text_1
        "50%"
        "52%"
        "44"
        red
        ("THE " ++ meeting ++ numberPostfix meeting ++ " CHAPTER MEETING HELD ON")
    , text_date_upper_case_1
        "50%"
        "57%"
        "44"
        red
        (String.toUpper dateAndVenue)
    ]


textSignature : String -> List (Svg Msg)
textSignature signature =
    case String.lines signature of
        [ firstLine, secondLine, thirdLine ] ->
            [ text_1
                "74%"
                "70%"
                "28"
                blue
                firstLine
            , text_italic_1
                "74%"
                "73%"
                "23"
                blue
                secondLine
            , text_italic_1
                "74%"
                "75%"
                "23"
                blue
                thirdLine
            ]

        [ firstLine, secondLine ] ->
            [ text_1
                "74%"
                "70%"
                "28"
                blue
                firstLine
            , text_italic_1
                "74%"
                "73%"
                "23"
                blue
                secondLine
            ]

        [ firstLine ] ->
            [ text_1
                "74%"
                "70%"
                "28"
                blue
                firstLine
            ]

        _ ->
            [ text_error_1
                "75%"
                "70%"
                "[Ensure the signature is 1-3 lines]"
            ]


getSection : String -> String -> String
getSection sectionName editorText =
    case
        List.head
            (List.filter
                (String.startsWith
                    sectionName
                )
                (listOfSections
                    editorText
                )
            )
    of
        Nothing ->
            "[Missing Section : " ++ sectionName ++ "]"

        Just section ->
            String.join
                "\n"
                (List.drop
                    1
                    (String.split
                        "\n"
                        section
                    )
                )



--  getSection
--      "Club"
--      "Meeting\n 100\n Club\n Hogwarts Toastmasters Club\n" ==
--
--  "Club\nHogwarts Toastmasters Club"


getWinner : Int -> String -> ( String, String )
getWinner winnerNo editorText =
    case
        Array.get
            winnerNo
            (Array.fromList
                (listOfWinners
                    editorText
                )
            )
    of
        Nothing ->
            ( "", "" )

        Just winner ->
            winner



--  getWinner
--      1
--      (   "Meeting\n"
--      ++  "  100\n"
--      ++  "\n"
--      ++  "Speaker\n"
--      ++  "  Albus\n"
--      ++  "Evaluator\n"
--      ++  "  Snape\n"
--      )   ==
--
--  ("Evaluator", "Snape")


view : Model -> Html Msg
view model =
    div []
        (List.concat
            [ [ svg
                    [ viewBox "0 0 2100 1200" ]
                    (List.concat
                        [ rectangles
                        , tmLogoAndWordMark
                        , textClubName
                            (getSection
                                "Club"
                                model.editorText
                            )
                        , if model.page == 0 then
                            -- cover page, 0th page
                            textStartPage
                                (getSection
                                    "Meeting"
                                    model.editorText
                                )
                                (getSection
                                    "Date and Venue"
                                    model.editorText
                                )

                          else if modBy 2 model.page == 1 then
                            -- result anticipation, 1st page, 3rd page, 5th page ...
                            textAnticipationPage
                                (getWinner
                                    ((model.page
                                        - 1
                                     )
                                        // 2
                                    )
                                    model.editorText
                                )

                          else
                            -- certificate of the winner, 2nd page, 4th page, 6th page ...
                            List.concat
                                [ textResultPage
                                    (getWinner
                                        ((model.page
                                            - 2
                                         )
                                            // 2
                                        )
                                        model.editorText
                                    )
                                    (getSection
                                        "Meeting"
                                        model.editorText
                                    )
                                    (getSection
                                        "Date and Venue"
                                        model.editorText
                                    )
                                , textSignature
                                    (getSection
                                        "Signature"
                                        model.editorText
                                    )
                                ]
                        , buttons
                            model.page
                            (getMaxPage
                                model.editorText
                            )
                        ]
                    )
              ]
            , if model.editorMode then
                -- display text editor field if editor mode is on
                [ textarea
                    [ rows 32
                    , cols 32
                    , spellcheck False
                    , value model.editorText
                    , onInput UpdateTextAndPage
                    ]
                    []
                , button
                    [ Html.Events.onClick OpenEditor ]
                    [ Html.text "X" ]
                ]

              else
                -- give an option to open editor if editor mode is off
                [ button
                    [ Html.Events.onClick OpenEditor ]
                    [ Html.text "Edit certificates" ]
                ]
            ]
        )
