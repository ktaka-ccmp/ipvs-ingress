; ModuleID = 'xlb_kern.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.vip = type { %union.anon.1, i16, i16, i8 }
%union.anon.1 = type { [4 x i32] }
%struct.flow = type { %struct.vip, %struct.sip }
%struct.sip = type { %union.anon.2, i16, i16, i8 }
%union.anon.2 = type { [4 x i32] }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }

@service = global %struct.bpf_map_def { i32 1, i32 24, i32 8, i32 256, i32 0, i32 0, i32 0 }, section "maps", align 4
@linklist = global %struct.bpf_map_def { i32 1, i32 8, i32 8, i32 256, i32 0, i32 0, i32 0 }, section "maps", align 4
@worker = global %struct.bpf_map_def { i32 1, i32 8, i32 40, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@lbcache = global %struct.bpf_map_def { i32 9, i32 48, i32 8, i32 200, i32 0, i32 0, i32 0 }, section "maps", align 4
@svcid = global %struct.bpf_map_def { i32 1, i32 2, i32 24, i32 256, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [7 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @_xdp_tx_iptunnel to i8*), i8* bitcast (%struct.bpf_map_def* @lbcache to i8*), i8* bitcast (%struct.bpf_map_def* @linklist to i8*), i8* bitcast (%struct.bpf_map_def* @service to i8*), i8* bitcast (%struct.bpf_map_def* @svcid to i8*), i8* bitcast (%struct.bpf_map_def* @worker to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @_xdp_tx_iptunnel(%struct.xdp_md* %xdp) #0 section "xdp_tx_iptunnel" {
  %vip.i = alloca %struct.vip, align 4
  %flow.i = alloca %struct.flow, align 4
  %wkid.i = alloca i64, align 8
  %next_wkid.i = alloca i64, align 8
  %sip.sroa.5.i = alloca [3 x i32], align 4
  %sip.sroa.8.i = alloca [3 x i8], align 1
  %1 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %xdp, i64 0, i32 1
  %2 = load i32, i32* %1, align 4, !tbaa !1
  %3 = zext i32 %2 to i64
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %xdp, i64 0, i32 0
  %5 = load i32, i32* %4, align 4, !tbaa !6
  %6 = zext i32 %5 to i64
  %7 = inttoptr i64 %6 to %struct.ethhdr*
  %8 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %7, i64 1
  %9 = inttoptr i64 %3 to %struct.ethhdr*
  %10 = icmp ugt %struct.ethhdr* %8, %9
  br i1 %10, label %182, label %11

; <label>:11                                      ; preds = %0
  %12 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %7, i64 0, i32 2
  %13 = load i16, i16* %12, align 1, !tbaa !7
  %14 = icmp eq i16 %13, 8
  br i1 %14, label %15, label %182

; <label>:15                                      ; preds = %11
  %16 = inttoptr i64 %3 to i8*
  %17 = inttoptr i64 %6 to i8*
  %18 = bitcast %struct.vip* %vip.i to i8*
  call void @llvm.lifetime.start(i64 24, i8* %18) #3
  call void @llvm.memset.p0i8.i64(i8* %18, i8 0, i64 24, i32 4, i1 false) #3
  %19 = getelementptr inbounds i8, i8* %17, i64 34
  %20 = bitcast i8* %19 to %struct.iphdr*
  %21 = inttoptr i64 %3 to %struct.iphdr*
  %22 = icmp ugt %struct.iphdr* %20, %21
  br i1 %22, label %handle_ipv4.exit, label %23

; <label>:23                                      ; preds = %15
  %24 = getelementptr inbounds i8, i8* %17, i64 23
  %25 = load i8, i8* %24, align 1, !tbaa !10
  %26 = zext i8 %25 to i32
  switch i32 %26, label %41 [
    i32 6, label %27
    i32 17, label %34
  ]

; <label>:27                                      ; preds = %23
  %28 = getelementptr inbounds i8, i8* %17, i64 54
  %29 = icmp ugt i8* %28, %16
  br i1 %29, label %handle_ipv4.exit, label %30

; <label>:30                                      ; preds = %27
  %31 = getelementptr inbounds i8, i8* %17, i64 36
  %32 = bitcast i8* %31 to i16*
  %33 = load i16, i16* %32, align 2, !tbaa !12
  br label %41

; <label>:34                                      ; preds = %23
  %35 = getelementptr inbounds i8, i8* %17, i64 42
  %36 = icmp ugt i8* %35, %16
  br i1 %36, label %handle_ipv4.exit, label %37

; <label>:37                                      ; preds = %34
  %38 = getelementptr inbounds i8, i8* %17, i64 36
  %39 = bitcast i8* %38 to i16*
  %40 = load i16, i16* %39, align 2, !tbaa !14
  br label %41

; <label>:41                                      ; preds = %37, %30, %23
  %.0.i.ph.shrunk.i = phi i16 [ 0, %23 ], [ %33, %30 ], [ %40, %37 ]
  %42 = getelementptr inbounds %struct.vip, %struct.vip* %vip.i, i64 0, i32 3
  store i8 %25, i8* %42, align 4, !tbaa !16
  %43 = getelementptr inbounds %struct.vip, %struct.vip* %vip.i, i64 0, i32 2
  store i16 2, i16* %43, align 2, !tbaa !18
  %44 = getelementptr inbounds i8, i8* %17, i64 30
  %45 = bitcast i8* %44 to i32*
  %46 = load i32, i32* %45, align 4, !tbaa !19
  %47 = getelementptr inbounds %struct.vip, %struct.vip* %vip.i, i64 0, i32 0, i32 0, i64 0
  store i32 %46, i32* %47, align 4, !tbaa !20
  %48 = getelementptr inbounds %struct.vip, %struct.vip* %vip.i, i64 0, i32 1
  store i16 %.0.i.ph.shrunk.i, i16* %48, align 4, !tbaa !21
  %49 = getelementptr inbounds i8, i8* %17, i64 16
  %50 = bitcast i8* %49 to i16*
  %51 = load i16, i16* %50, align 2, !tbaa !22
  %52 = tail call i16 @llvm.bswap.i16(i16 %51) #3
  %53 = bitcast %struct.flow* %flow.i to i8*
  call void @llvm.lifetime.start(i64 48, i8* %53) #3
  call void @llvm.memset.p0i8.i64(i8* %53, i8 0, i64 48, i32 4, i1 false) #3
  %54 = bitcast i64* %wkid.i to i8*
  call void @llvm.lifetime.start(i64 8, i8* %54) #3
  %55 = bitcast i64* %next_wkid.i to i8*
  call void @llvm.lifetime.start(i64 8, i8* %55) #3
  %56 = bitcast [3 x i32]* %sip.sroa.5.i to i8*
  call void @llvm.lifetime.start(i64 12, i8* %56)
  %57 = getelementptr inbounds [3 x i8], [3 x i8]* %sip.sroa.8.i, i64 0, i64 0
  call void @llvm.lifetime.start(i64 3, i8* %57)
  call void @llvm.memset.p0i8.i64(i8* %56, i8 0, i64 12, i32 4, i1 false)
  call void @llvm.memset.p0i8.i64(i8* %57, i8 0, i64 3, i32 1, i1 false)
  %58 = load i8, i8* %24, align 1, !tbaa !10
  %59 = zext i8 %58 to i32
  switch i32 %59, label %72 [
    i32 6, label %60
    i32 17, label %66
  ]

; <label>:60                                      ; preds = %41
  %61 = getelementptr inbounds i8, i8* %17, i64 54
  %62 = icmp ugt i8* %61, %16
  br i1 %62, label %get_sport.exit.i, label %63

; <label>:63                                      ; preds = %60
  %64 = bitcast i8* %19 to i16*
  %65 = load i16, i16* %64, align 4, !tbaa !23
  br label %72

; <label>:66                                      ; preds = %41
  %67 = getelementptr inbounds i8, i8* %17, i64 42
  %68 = icmp ugt i8* %67, %16
  br i1 %68, label %get_sport.exit.i, label %69

; <label>:69                                      ; preds = %66
  %70 = bitcast i8* %19 to i16*
  %71 = load i16, i16* %70, align 2, !tbaa !24
  br label %72

; <label>:72                                      ; preds = %69, %63, %41
  %.0.i2.ph.shrunk.i = phi i16 [ 0, %41 ], [ %65, %63 ], [ %71, %69 ]
  %73 = getelementptr inbounds i8, i8* %17, i64 26
  %74 = bitcast i8* %73 to i32*
  %75 = load i32, i32* %74, align 4, !tbaa !25
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %53, i8* nonnull %18, i64 24, i32 4, i1 false) #3, !tbaa.struct !26
  %76 = getelementptr inbounds %struct.flow, %struct.flow* %flow.i, i64 0, i32 1, i32 0, i32 0, i64 0
  store i32 %75, i32* %76, align 4
  %77 = getelementptr inbounds %struct.flow, %struct.flow* %flow.i, i64 0, i32 1, i32 0, i32 0, i64 1
  %78 = bitcast i32* %77 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %78, i8* %56, i64 12, i32 4, i1 false) #3
  %79 = getelementptr inbounds %struct.flow, %struct.flow* %flow.i, i64 0, i32 1, i32 1
  store i16 %.0.i2.ph.shrunk.i, i16* %79, align 4
  %80 = getelementptr inbounds %struct.flow, %struct.flow* %flow.i, i64 0, i32 1, i32 2
  store i16 2, i16* %80, align 2
  %81 = getelementptr inbounds %struct.flow, %struct.flow* %flow.i, i64 0, i32 1, i32 3
  store i8 %58, i8* %81, align 4
  %82 = getelementptr inbounds i8, i8* %53, i64 45
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %82, i8* %57, i64 3, i32 1, i1 false) #3
  %83 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* nonnull bitcast (%struct.bpf_map_def* @lbcache to i8*), i8* %53) #3
  %84 = bitcast i8* %83 to i64*
  %85 = icmp eq i8* %83, null
  br i1 %85, label %86, label %99

; <label>:86                                      ; preds = %72
  %87 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* nonnull bitcast (%struct.bpf_map_def* @service to i8*), i8* nonnull %18) #3
  %88 = bitcast i8* %87 to i64*
  %89 = icmp eq i8* %87, null
  br i1 %89, label %get_sport.exit.i, label %90

; <label>:90                                      ; preds = %86
  %91 = load i64, i64* %88, align 8, !tbaa !29
  store i64 %91, i64* %wkid.i, align 8, !tbaa !29
  %92 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* nonnull bitcast (%struct.bpf_map_def* @lbcache to i8*), i8* nonnull %53, i8* %54, i64 0) #3
  %93 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* nonnull bitcast (%struct.bpf_map_def* @linklist to i8*), i8* %54) #3
  %94 = icmp eq i8* %93, null
  br i1 %94, label %get_sport.exit.i, label %95

; <label>:95                                      ; preds = %90
  %96 = bitcast i8* %93 to i64*
  %97 = load i64, i64* %96, align 8, !tbaa !29
  store i64 %97, i64* %next_wkid.i, align 8, !tbaa !29
  %98 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* nonnull bitcast (%struct.bpf_map_def* @service to i8*), i8* nonnull %18, i8* %55, i64 0) #3
  br label %99

; <label>:99                                      ; preds = %95, %72
  %wkid_p.0.i = phi i64* [ %84, %72 ], [ %88, %95 ]
  %100 = load i64, i64* %wkid_p.0.i, align 8, !tbaa !29
  store i64 %100, i64* %wkid.i, align 8, !tbaa !29
  %101 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* nonnull bitcast (%struct.bpf_map_def* @worker to i8*), i8* %54) #3
  %102 = icmp eq i8* %101, null
  br i1 %102, label %get_sport.exit.i, label %103

; <label>:103                                     ; preds = %99
  %104 = getelementptr inbounds i8, i8* %101, i64 32
  %105 = bitcast i8* %104 to i16*
  %106 = load i16, i16* %105, align 4, !tbaa !31
  %107 = icmp eq i16 %106, 2
  br i1 %107, label %108, label %get_sport.exit.i

; <label>:108                                     ; preds = %103
  %109 = bitcast %struct.xdp_md* %xdp to i8*
  %110 = call i32 inttoptr (i64 44 to i32 (i8*, i32)*)(i8* %109, i32 -20) #3
  %111 = icmp eq i32 %110, 0
  br i1 %111, label %112, label %get_sport.exit.i

; <label>:112                                     ; preds = %108
  %113 = load i32, i32* %4, align 4, !tbaa !6
  %114 = zext i32 %113 to i64
  %115 = inttoptr i64 %114 to i8*
  %116 = load i32, i32* %1, align 4, !tbaa !1
  %117 = zext i32 %116 to i64
  %118 = inttoptr i64 %114 to %struct.ethhdr*
  %119 = getelementptr i8, i8* %115, i64 14
  %120 = getelementptr i8, i8* %115, i64 20
  %121 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %118, i64 1
  %122 = inttoptr i64 %117 to %struct.ethhdr*
  %123 = icmp ugt %struct.ethhdr* %121, %122
  br i1 %123, label %get_sport.exit.i, label %124

; <label>:124                                     ; preds = %112
  %125 = getelementptr inbounds i8, i8* %115, i64 34
  %126 = bitcast i8* %125 to %struct.ethhdr*
  %127 = icmp ugt %struct.ethhdr* %126, %122
  br i1 %127, label %get_sport.exit.i, label %128

; <label>:128                                     ; preds = %124
  %129 = bitcast i8* %125 to %struct.iphdr*
  %130 = inttoptr i64 %117 to %struct.iphdr*
  %131 = icmp ugt %struct.iphdr* %129, %130
  br i1 %131, label %get_sport.exit.i, label %132

; <label>:132                                     ; preds = %128
  %133 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %118, i64 0, i32 1, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %133, i8* %120, i64 6, i32 1, i1 false) #3
  %134 = getelementptr inbounds i8, i8* %101, i64 34
  %135 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %118, i64 0, i32 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %135, i8* %134, i64 6, i32 1, i1 false) #3
  %136 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %118, i64 0, i32 2
  store i16 8, i16* %136, align 1, !tbaa !7
  store i8 69, i8* %119, align 4
  %137 = bitcast i8* %120 to i16*
  store i16 0, i16* %137, align 2, !tbaa !33
  %138 = getelementptr inbounds i8, i8* %115, i64 23
  store i8 4, i8* %138, align 1, !tbaa !10
  %139 = getelementptr inbounds i8, i8* %115, i64 24
  %140 = bitcast i8* %139 to i16*
  %141 = getelementptr inbounds i8, i8* %115, i64 15
  store i8 0, i8* %141, align 1, !tbaa !34
  %142 = add i16 %52, 20
  %143 = call i16 @llvm.bswap.i16(i16 %142) #3
  %144 = getelementptr inbounds i8, i8* %115, i64 16
  %145 = bitcast i8* %144 to i16*
  store i16 %143, i16* %145, align 2, !tbaa !22
  %146 = getelementptr inbounds i8, i8* %101, i64 16
  %147 = bitcast i8* %146 to i32*
  %148 = load i32, i32* %147, align 4, !tbaa !20
  %149 = getelementptr inbounds i8, i8* %115, i64 30
  %150 = bitcast i8* %149 to i32*
  store i32 %148, i32* %150, align 4, !tbaa !19
  %151 = bitcast i8* %101 to i32*
  %152 = load i32, i32* %151, align 4, !tbaa !20
  %153 = getelementptr inbounds i8, i8* %115, i64 26
  %154 = bitcast i8* %153 to i32*
  store i32 %152, i32* %154, align 4, !tbaa !25
  %155 = getelementptr inbounds i8, i8* %115, i64 22
  store i8 8, i8* %155, align 4, !tbaa !35
  %156 = bitcast i8* %119 to i16*
  %157 = load i16, i16* %156, align 2, !tbaa !28
  %158 = zext i16 %157 to i32
  %159 = getelementptr inbounds i8, i8* %115, i64 18
  %160 = bitcast i8* %159 to i16*
  %161 = zext i16 %143 to i32
  %162 = add nuw nsw i32 %158, %161
  %163 = load i16, i16* %160, align 2, !tbaa !28
  %164 = zext i16 %163 to i32
  %165 = add nuw nsw i32 %162, %164
  %166 = bitcast i8* %155 to i16*
  %167 = load i16, i16* %166, align 2, !tbaa !28
  %168 = zext i16 %167 to i32
  %169 = add nuw nsw i32 %165, %168
  %170 = and i32 %152, 65535
  %171 = add nuw nsw i32 %169, %170
  %172 = lshr i32 %152, 16
  %173 = add nuw nsw i32 %171, %172
  %174 = and i32 %148, 65535
  %175 = add nuw nsw i32 %173, %174
  %176 = lshr i32 %148, 16
  %177 = add i32 %175, %176
  %178 = lshr i32 %177, 16
  %179 = add i32 %178, %177
  %180 = xor i32 %179, 65535
  %181 = trunc i32 %180 to i16
  store i16 %181, i16* %140, align 2, !tbaa !36
  br label %get_sport.exit.i

get_sport.exit.i:                                 ; preds = %132, %128, %124, %112, %108, %103, %99, %90, %86, %66, %60
  %.0.i = phi i32 [ 3, %132 ], [ 2, %86 ], [ 2, %90 ], [ 2, %103 ], [ 2, %99 ], [ 1, %108 ], [ 1, %128 ], [ 1, %124 ], [ 1, %112 ], [ 1, %60 ], [ 1, %66 ]
  call void @llvm.lifetime.end(i64 12, i8* %56)
  call void @llvm.lifetime.end(i64 3, i8* %57)
  call void @llvm.lifetime.end(i64 8, i8* %55) #3
  call void @llvm.lifetime.end(i64 8, i8* %54) #3
  call void @llvm.lifetime.end(i64 48, i8* %53) #3
  br label %handle_ipv4.exit

handle_ipv4.exit:                                 ; preds = %15, %27, %34, %get_sport.exit.i
  %.1.i = phi i32 [ %.0.i, %get_sport.exit.i ], [ 1, %15 ], [ 1, %27 ], [ 1, %34 ]
  call void @llvm.lifetime.end(i64 24, i8* %18) #3
  br label %182

; <label>:182                                     ; preds = %11, %0, %handle_ipv4.exit
  %.0 = phi i32 [ %.1.i, %handle_ipv4.exit ], [ 1, %0 ], [ 2, %11 ]
  ret i32 %.0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #1

; Function Attrs: nounwind readnone
declare i16 @llvm.bswap.i16(i16) #2

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone }
attributes #3 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.1-24 (tags/RELEASE_381/final)"}
!1 = !{!2, !3, i64 4}
!2 = !{!"xdp_md", !3, i64 0, !3, i64 4, !3, i64 8, !3, i64 12, !3, i64 16}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!2, !3, i64 0}
!7 = !{!8, !9, i64 12}
!8 = !{!"ethhdr", !4, i64 0, !4, i64 6, !9, i64 12}
!9 = !{!"short", !4, i64 0}
!10 = !{!11, !4, i64 9}
!11 = !{!"iphdr", !4, i64 0, !4, i64 0, !4, i64 1, !9, i64 2, !9, i64 4, !9, i64 6, !4, i64 8, !4, i64 9, !9, i64 10, !3, i64 12, !3, i64 16}
!12 = !{!13, !9, i64 2}
!13 = !{!"tcphdr", !9, i64 0, !9, i64 2, !3, i64 4, !3, i64 8, !9, i64 12, !9, i64 12, !9, i64 13, !9, i64 13, !9, i64 13, !9, i64 13, !9, i64 13, !9, i64 13, !9, i64 13, !9, i64 13, !9, i64 14, !9, i64 16, !9, i64 18}
!14 = !{!15, !9, i64 2}
!15 = !{!"udphdr", !9, i64 0, !9, i64 2, !9, i64 4, !9, i64 6}
!16 = !{!17, !4, i64 20}
!17 = !{!"vip", !4, i64 0, !9, i64 16, !9, i64 18, !4, i64 20}
!18 = !{!17, !9, i64 18}
!19 = !{!11, !3, i64 16}
!20 = !{!3, !3, i64 0}
!21 = !{!17, !9, i64 16}
!22 = !{!11, !9, i64 2}
!23 = !{!13, !9, i64 0}
!24 = !{!15, !9, i64 0}
!25 = !{!11, !3, i64 12}
!26 = !{i64 0, i64 16, !27, i64 0, i64 4, !20, i64 16, i64 2, !28, i64 18, i64 2, !28, i64 20, i64 1, !27}
!27 = !{!4, !4, i64 0}
!28 = !{!9, !9, i64 0}
!29 = !{!30, !30, i64 0}
!30 = !{!"long long", !4, i64 0}
!31 = !{!32, !9, i64 32}
!32 = !{!"iptnl_info", !4, i64 0, !4, i64 16, !9, i64 32, !4, i64 34}
!33 = !{!11, !9, i64 6}
!34 = !{!11, !4, i64 1}
!35 = !{!11, !4, i64 8}
!36 = !{!11, !9, i64 10}
