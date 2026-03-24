; ModuleID = 'my_code.c'
source_filename = "my_code.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [17 x i8] c"Error occurred!\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [25 x i8] c"Negative value detected\0A\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [12 x i8] c"Result: %d\0A\00", align 1, !dbg !12

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @error_handler() #0 !dbg !27 {
  %1 = call i32 (ptr, ...) @printf(ptr noundef @.str), !dbg !30
  call void @exit(i32 noundef 1) #5, !dbg !31
  unreachable, !dbg !31
}

declare i32 @printf(ptr noundef, ...) #1

; Function Attrs: noreturn nounwind
declare void @exit(i32 noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @process_value(i32 noundef %0, i32 noundef %1) #0 !dbg !32 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !37, metadata !DIExpression()), !dbg !38
  store i32 %1, ptr %5, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !39, metadata !DIExpression()), !dbg !40
  call void @llvm.dbg.declare(metadata ptr %6, metadata !41, metadata !DIExpression()), !dbg !42
  store i32 0, ptr %6, align 4, !dbg !42
  %7 = load i32, ptr %4, align 4, !dbg !43
  %8 = icmp slt i32 %7, 0, !dbg !45
  br i1 %8, label %9, label %11, !dbg !46

9:                                                ; preds = %2
  %10 = call i32 (ptr, ...) @printf(ptr noundef @.str.1), !dbg !47
  store i32 -1, ptr %3, align 4, !dbg !49
  br label %18, !dbg !49

11:                                               ; preds = %2
  %12 = load i32, ptr %4, align 4, !dbg !50
  %13 = icmp sgt i32 %12, 100, !dbg !52
  br i1 %13, label %14, label %15, !dbg !53

14:                                               ; preds = %11
  call void @error_handler(), !dbg !54
  br label %15, !dbg !56

15:                                               ; preds = %14, %11
  %16 = load i32, ptr %4, align 4, !dbg !57
  %17 = mul nsw i32 %16, 2, !dbg !58
  store i32 %17, ptr %3, align 4, !dbg !59
  br label %18, !dbg !59

18:                                               ; preds = %15, %9
  %19 = load i32, ptr %3, align 4, !dbg !60
  ret i32 %19, !dbg !60
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !61 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !66, metadata !DIExpression()), !dbg !67
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !68, metadata !DIExpression()), !dbg !69
  call void @llvm.dbg.declare(metadata ptr %6, metadata !70, metadata !DIExpression()), !dbg !71
  call void @llvm.dbg.declare(metadata ptr %7, metadata !72, metadata !DIExpression()), !dbg !73
  store i32 50, ptr %7, align 4, !dbg !73
  %8 = load i32, ptr %4, align 4, !dbg !74
  %9 = icmp sgt i32 %8, 1, !dbg !76
  br i1 %9, label %10, label %15, !dbg !77

10:                                               ; preds = %2
  %11 = load ptr, ptr %5, align 8, !dbg !78
  %12 = getelementptr inbounds ptr, ptr %11, i64 1, !dbg !78
  %13 = load ptr, ptr %12, align 8, !dbg !78
  %14 = call i32 @atoi(ptr noundef %13) #6, !dbg !80
  store i32 %14, ptr %7, align 4, !dbg !81
  br label %15, !dbg !82

15:                                               ; preds = %10, %2
  %16 = load i32, ptr %7, align 4, !dbg !83
  %17 = call i32 @process_value(i32 noundef %16, i32 noundef 0), !dbg !84
  store i32 %17, ptr %6, align 4, !dbg !85
  %18 = load i32, ptr %6, align 4, !dbg !86
  %19 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %18), !dbg !87
  ret i32 0, !dbg !88
}

; Function Attrs: nounwind willreturn memory(read)
declare i32 @atoi(ptr noundef) #4

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nounwind willreturn memory(read) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind willreturn memory(read) }

!llvm.dbg.cu = !{!17}
!llvm.module.flags = !{!19, !20, !21, !22, !23, !24, !25}
!llvm.ident = !{!26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 5, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "my_code.c", directory: "/home/samyak/CD", checksumkind: CSK_MD5, checksum: "ee413c6a70ebbc8b7ca6415709dc002f")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 17)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 12, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 200, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 25)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 33, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 96, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 12)
!17 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !18, splitDebugInlining: false, nameTableKind: None)
!18 = !{!0, !7, !12}
!19 = !{i32 7, !"Dwarf Version", i32 5}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = !{i32 8, !"PIC Level", i32 2}
!23 = !{i32 7, !"PIE Level", i32 2}
!24 = !{i32 7, !"uwtable", i32 2}
!25 = !{i32 7, !"frame-pointer", i32 2}
!26 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!27 = distinct !DISubprogram(name: "error_handler", scope: !2, file: !2, line: 4, type: !28, scopeLine: 4, spFlags: DISPFlagDefinition, unit: !17)
!28 = !DISubroutineType(types: !29)
!29 = !{null}
!30 = !DILocation(line: 5, column: 5, scope: !27)
!31 = !DILocation(line: 6, column: 5, scope: !27)
!32 = distinct !DISubprogram(name: "process_value", scope: !2, file: !2, line: 9, type: !33, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !36)
!33 = !DISubroutineType(types: !34)
!34 = !{!35, !35, !35}
!35 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!36 = !{}
!37 = !DILocalVariable(name: "val", arg: 1, scope: !32, file: !2, line: 9, type: !35)
!38 = !DILocation(line: 9, column: 23, scope: !32)
!39 = !DILocalVariable(name: "x", arg: 2, scope: !32, file: !2, line: 9, type: !35)
!40 = !DILocation(line: 9, column: 32, scope: !32)
!41 = !DILocalVariable(name: "v", scope: !32, file: !2, line: 10, type: !35)
!42 = !DILocation(line: 10, column: 9, scope: !32)
!43 = !DILocation(line: 11, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !32, file: !2, line: 11, column: 9)
!45 = !DILocation(line: 11, column: 13, scope: !44)
!46 = !DILocation(line: 11, column: 9, scope: !32)
!47 = !DILocation(line: 12, column: 9, scope: !48)
!48 = distinct !DILexicalBlock(scope: !44, file: !2, line: 11, column: 18)
!49 = !DILocation(line: 13, column: 9, scope: !48)
!50 = !DILocation(line: 15, column: 9, scope: !51)
!51 = distinct !DILexicalBlock(scope: !32, file: !2, line: 15, column: 9)
!52 = !DILocation(line: 15, column: 13, scope: !51)
!53 = !DILocation(line: 15, column: 9, scope: !32)
!54 = !DILocation(line: 17, column: 9, scope: !55)
!55 = distinct !DILexicalBlock(scope: !51, file: !2, line: 15, column: 20)
!56 = !DILocation(line: 18, column: 5, scope: !55)
!57 = !DILocation(line: 19, column: 12, scope: !32)
!58 = !DILocation(line: 19, column: 16, scope: !32)
!59 = !DILocation(line: 19, column: 5, scope: !32)
!60 = !DILocation(line: 20, column: 1, scope: !32)
!61 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 22, type: !62, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !36)
!62 = !DISubroutineType(types: !63)
!63 = !{!35, !35, !64}
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!66 = !DILocalVariable(name: "argc", arg: 1, scope: !61, file: !2, line: 22, type: !35)
!67 = !DILocation(line: 22, column: 14, scope: !61)
!68 = !DILocalVariable(name: "argv", arg: 2, scope: !61, file: !2, line: 22, type: !64)
!69 = !DILocation(line: 22, column: 26, scope: !61)
!70 = !DILocalVariable(name: "result", scope: !61, file: !2, line: 23, type: !35)
!71 = !DILocation(line: 23, column: 9, scope: !61)
!72 = !DILocalVariable(name: "input", scope: !61, file: !2, line: 24, type: !35)
!73 = !DILocation(line: 24, column: 9, scope: !61)
!74 = !DILocation(line: 26, column: 9, scope: !75)
!75 = distinct !DILexicalBlock(scope: !61, file: !2, line: 26, column: 9)
!76 = !DILocation(line: 26, column: 14, scope: !75)
!77 = !DILocation(line: 26, column: 9, scope: !61)
!78 = !DILocation(line: 27, column: 22, scope: !79)
!79 = distinct !DILexicalBlock(scope: !75, file: !2, line: 26, column: 19)
!80 = !DILocation(line: 27, column: 17, scope: !79)
!81 = !DILocation(line: 27, column: 15, scope: !79)
!82 = !DILocation(line: 28, column: 5, scope: !79)
!83 = !DILocation(line: 30, column: 28, scope: !61)
!84 = !DILocation(line: 30, column: 14, scope: !61)
!85 = !DILocation(line: 30, column: 12, scope: !61)
!86 = !DILocation(line: 33, column: 28, scope: !61)
!87 = !DILocation(line: 33, column: 5, scope: !61)
!88 = !DILocation(line: 34, column: 5, scope: !61)
