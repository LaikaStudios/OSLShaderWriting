/*
 *  Copyright 2023 Laika, LLC. Authored by Mitch Prater.
 *
 *  Licensed under the Apache License Version 2.0 http://apache.org/licenses/LICENSE-2.0,
 *  or the MIT license http://opensource.org/licenses/MIT, at your option.
 *
 *  This program may not be copied, modified, or distributed except according to those terms.
 */
#define UI_PARAMS(L) \
    float L##_in = 0.0 \
    [[ \
        string page = #L, \
        string label = "in", \
        string help = \
            "A float pattern value. " \
    ]], \
\
    color L##_In = color(0.0) \
    [[ \
        string page = #L, \
        string label = "In", \
        string help = \
            "A tuple pattern value: color, point, vector, normal. " \
    ]], \
\
    float L##_Size = 1.0 \
    [[ \
        string page = #L, \
        string label = "Size", \
        string help = \
            "The <b>Size</b> of the " #L " pattern. " \
    ]], \
\
    float L##_Gain = 1.0 \
    [[ \
        string page = #L, \
        string label = "Gain", \
        int slider = 1, float slidermin = 0.0, float slidermax = 2.0, \
        string help = \
            "Pre-scales the " #L " pattern. " \
    ]]
