module.children = {
    moduleNameMapper: {
        "^/opt/nodejs/(.*)": "<rootDir>/src/layers/utils/$1", //map nodejs folders to layers folder
    },
    transform: {
        "^.+\\.(t|j)sx?$": "@swc/jest" //use SWC to compile all sourcefiles before running tests
    }
}