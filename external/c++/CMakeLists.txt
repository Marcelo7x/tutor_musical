project(rec)

add_library(
    ${PROJECT_NAME}
    SHARED
        rec.cpp
        rec.def
)

target_link_libraries(
    ${PROJECT_NAME}
    sndfile
    portaudio
)