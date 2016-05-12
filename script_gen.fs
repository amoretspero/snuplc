open System
open System.Collections
open System.Collections.Generic
open System.Linq
open System.IO

let generateOneFile (idxArr : int []) (file : string []) =
    let fileLen = file.Length
    let mutable fileContent = ref ([| |] : string [])
    for i=0 to fileLen-1 do
        //if (idxArr |> Array.contains(i)) then
        if (Array.exists (fun x -> x = i) idxArr) then
            fileContent.Value <- Array.append fileContent.Value [| "//" + file.[i] |]
        else
            fileContent.Value <- Array.append fileContent.Value [| file.[i] |]
    fileContent.Value

let writeOneFile (fileIdx : int) (fileContent : string []) =
    if File.Exists("./test/semanal/strings"+fileIdx.ToString()+".mod") then
        File.Delete("./test/semanal/strings"+fileIdx.ToString()+".mod")
    let fileContentConcat = String.Join("\n", fileContent)
    File.WriteAllLines("./test/semanal/strings"+fileIdx.ToString()+".mod", fileContent)
    //File.WriteAllText("./test/semanal/strings"+fileIdx.ToString()+".mod", fileContentConcat)

let main() =
    let originalFile = File.ReadAllLines("./test/semanal/strings.mod")
    let fileLineCnt = originalFile.Length
    let mutable idx = ref ([| |] : int [])
    for i = 0 to fileLineCnt - 1 do
        if (originalFile.[i].Contains("// fail")) then
            idx.Value <- Array.append idx.Value [| i |]
    let idxLen = idx.Value.Length
    for i = 0 to idxLen - 1 do
        //writeOneFile (i+1) (generateOneFile (Array.take (i+1) idx.Value) originalFile)
        writeOneFile (i+1) (generateOneFile idx.Value.[..i] originalFile)

main()