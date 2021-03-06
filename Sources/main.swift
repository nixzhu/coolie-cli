//
//  main.swift
//  Coolie
//
//  Created by NIX on 16/1/4.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation
import Coolie

func main(_ arguments: [String]) {

    let arguments = Arguments(arguments)

    let inputFilePathOption = Arguments.Option.Mixed(shortKey: "i", longKey: "input-file-path")
    let modelNameOption = Arguments.Option.Long(key: "model-name")

    guard let inputFilePath = arguments.valueOfOption(inputFilePathOption), let modelName = arguments.valueOfOption(modelNameOption) else {
        print("Usage: $ coolie -i JSONFilePath --model-name ModelName")
        return
    }

    let fileManager = FileManager.default

    guard fileManager.fileExists(atPath: inputFilePath) else {
        print("File NOT found at \(inputFilePath)")
        return
    }

    guard fileManager.isReadableFile(atPath: inputFilePath) else {
        print("No permission to read file at \(inputFilePath)")
        return
    }

    guard let data = fileManager.contents(atPath: inputFilePath) else {
        print("File is empty!")
        return
    }

    guard let jsonString = String(data: data, encoding: .utf8) else {
        print("File is NOT encoding with UTF8!")
        return
    }

    let coolie = Coolie(jsonString)

    let argumentLabelOption = Arguments.Option.Long(key: "argument-label")
    arguments.valueOfOption(argumentLabelOption).flatMap {
        Coolie.Config.argumentLabel = $0
    }
    let parameterNameOption = Arguments.Option.Long(key: "parameter-name")
    arguments.valueOfOption(parameterNameOption).flatMap {
        Coolie.Config.parameterName = $0
    }

    let constructorNameOption = Arguments.Option.Long(key: "constructor-name")
    arguments.valueOfOption(constructorNameOption).flatMap {
        Coolie.Config.constructorName = $0
    }

    let jsonDictionaryNameOption = Arguments.Option.Long(key: "json-dictionary-name")
    arguments.valueOfOption(jsonDictionaryNameOption).flatMap {
        Coolie.Config.jsonDictionaryName = $0
    }

    let debugOption = Arguments.Option.Long(key: "debug")
    Coolie.Config.debug = arguments.containsOption(debugOption)
    let throwsOption = Arguments.Option.Long(key: "throws")
    Coolie.Config.throwsEnabled = arguments.containsOption(throwsOption)
    let publicOption = Arguments.Option.Long(key: "public")
    Coolie.Config.publicEnabled = arguments.containsOption(publicOption)

    let modelTypeOption = Arguments.Option.Long(key: "model-type")
    let modelTypeRawValue = arguments.valueOfOption(modelTypeOption)?.lowercased()
    let modelType = modelTypeRawValue.flatMap({ Coolie.ModelType(rawValue: $0) }) ?? Coolie.ModelType.struct

    let iso8601DateFormatterNameOption = Arguments.Option.Long(key: "iso8601-date-formatter-name")
    if let iso8601DateFormatterName = arguments.valueOfOption(iso8601DateFormatterNameOption) {
        Coolie.Config.DateFormatterName.iso8601 = iso8601DateFormatterName
    }

    let dateOnlyDateFormatterNameOption = Arguments.Option.Long(key: "date-only-date-formatter-name")
    if let dateOnlyDateFormatterName = arguments.valueOfOption(dateOnlyDateFormatterNameOption) {
        Coolie.Config.DateFormatterName.dateOnly = dateOnlyDateFormatterName
    }

    let model = coolie.generateModel(
        name: modelName,
        type: modelType,
        argumentLabel: Coolie.Config.argumentLabel,
        constructorName: Coolie.Config.constructorName,
        jsonDictionaryName: Coolie.Config.jsonDictionaryName,
        debug: Coolie.Config.debug
    )

    model.flatMap({ print($0) })
}

main(CommandLine.arguments)
