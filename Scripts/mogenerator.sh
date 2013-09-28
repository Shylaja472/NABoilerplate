#!/bin/sh

#  mogenerator.sh
#  Add run script as a buildphase before compiling code
#  Requires mogenerator to run. Install from brew or download: http://rentzsch.github.io/mogenerator/
#  Created by Audun Kjelstrup on 9/23/13.
#  Copyright (c) 2013 Audun Kjelstrup. All rights reserved.


cd ${SOURCE_ROOT}/${PROJECT_NAME}
/usr/local/bin/mogenerator --template-var arc=true -m ${PROJECT_NAME}.xcdatamodeld -M CoreData/Machine -H CoreData/Human