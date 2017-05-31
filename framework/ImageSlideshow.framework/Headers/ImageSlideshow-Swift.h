// Generated by Apple Swift version 3.1 (swiftlang-802.0.53 clang-802.0.42)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if defined(__has_attribute) && __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import Foundation;
@import UIKit;
@import CoreGraphics;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIImageView;
@class UIImage;

/// A protocol that can be adapted by different Input Source providers
SWIFT_PROTOCOL("_TtP14ImageSlideshow11InputSource_")
@protocol InputSource
/// Load image from the source to image view.
/// \param imageView The image view to load the image into.
///
/// \param callback Callback called after the image was set to the image view.
///
/// \param image Image that was set to the image view.
///
- (void)loadTo:(UIImageView * _Nonnull)imageView with:(void (^ _Nonnull)(UIImage * _Nullable))callback;
@end


/// Input Source to image using AFNetworking
SWIFT_CLASS("_TtC14ImageSlideshow11AFURLSource")
@interface AFURLSource : NSObject <InputSource>
/// url to load
@property (nonatomic, copy) NSURL * _Nonnull url;
/// placeholder used before image is loaded
@property (nonatomic, strong) UIImage * _Nullable placeholder;
/// Initializes a new source with URL and placeholder
/// \param url a url to load
///
/// \param placeholder a placeholder used before image is loaded
///
- (nonnull instancetype)initWithUrl:(NSURL * _Nonnull)url placeholder:(UIImage * _Nullable)placeholder OBJC_DESIGNATED_INITIALIZER;
/// Initializes a new source with a URL string
/// \param urlString a string url to load
///
/// \param placeholder a placeholder used before image is loaded
///
- (nullable instancetype)initWithUrlString:(NSString * _Nonnull)urlString placeholder:(UIImage * _Nullable)placeholder OBJC_DESIGNATED_INITIALIZER;
- (void)loadTo:(UIImageView * _Nonnull)imageView with:(void (^ _Nonnull)(UIImage * _Nullable))callback;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// Input Source to image using Alamofire
SWIFT_CLASS("_TtC14ImageSlideshow15AlamofireSource")
@interface AlamofireSource : NSObject <InputSource>
/// url to load
@property (nonatomic, copy) NSURL * _Nonnull url;
/// placeholder used before image is loaded
@property (nonatomic, strong) UIImage * _Nullable placeholder;
/// Initializes a new source with a URL
/// \param url a url to load
///
/// \param placeholder a placeholder used before image is loaded
///
- (nonnull instancetype)initWithUrl:(NSURL * _Nonnull)url placeholder:(UIImage * _Nullable)placeholder OBJC_DESIGNATED_INITIALIZER;
/// Initializes a new source with a URL string
/// \param urlString a string url to load
///
/// \param placeholder a placeholder used before image is loaded
///
- (nullable instancetype)initWithUrlString:(NSString * _Nonnull)urlString placeholder:(UIImage * _Nullable)placeholder OBJC_DESIGNATED_INITIALIZER;
- (void)loadTo:(UIImageView * _Nonnull)imageView with:(void (^ _Nonnull)(UIImage * _Nullable))callback;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class ImageSlideshow;
@class UIButton;
@class UIColor;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC14ImageSlideshow33FullScreenSlideshowViewController")
@interface FullScreenSlideshowViewController : UIViewController
@property (nonatomic, strong) ImageSlideshow * _Nonnull slideshow;
/// Close button
@property (nonatomic, strong) UIButton * _Nonnull closeButton;
/// Closure called on page selection
@property (nonatomic, copy) void (^ _Nullable pageSelected)(NSInteger);
/// Index of initial image
@property (nonatomic) NSInteger initialPage;
/// Input sources to
@property (nonatomic, copy) NSArray<id <InputSource>> * _Nullable inputs;
/// Background color
@property (nonatomic, strong) UIColor * _Nonnull backgroundColor;
/// Enables/disable zoom
@property (nonatomic) BOOL zoomEnabled;
- (void)viewDidLoad;
@property (nonatomic, readonly) BOOL prefersStatusBarHidden;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidLayoutSubviews;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIScrollView;
@class UIPageControl;
@class ImageSlideshowItem;
@class ZoomAnimatedTransitioningDelegate;

/// Main view containing the Image Slideshow
SWIFT_CLASS("_TtC14ImageSlideshow14ImageSlideshow")
@interface ImageSlideshow : UIView
/// Scroll View to wrap the slideshow
@property (nonatomic, readonly, strong) UIScrollView * _Nonnull scrollView;
/// Page Control shown in the slideshow
@property (nonatomic, readonly, strong) UIPageControl * _Nonnull pageControl;
/// Current page
@property (nonatomic, readonly) NSInteger currentPage;
/// Called on each currentPage change
@property (nonatomic, copy) void (^ _Nullable currentPageChanged)(NSInteger);
/// Called on scrollViewWillBeginDragging
@property (nonatomic, copy) void (^ _Nullable willBeginDragging)(void);
/// Called on scrollViewDidEndDecelerating
@property (nonatomic, copy) void (^ _Nullable didEndDecelerating)(void);
/// Currenlty displayed slideshow item
@property (nonatomic, readonly, strong) ImageSlideshowItem * _Nullable currentSlideshowItem;
/// Current scroll view page. This may differ from <code>currentPage</code> as circular slider has two more dummy pages at indexes 0 and n-1 to provide fluent scrolling between first and last item.
@property (nonatomic, readonly) NSInteger scrollViewPage;
/// Input Sources loaded to slideshow
@property (nonatomic, readonly, copy) NSArray<id <InputSource>> * _Nonnull images;
/// Image Slideshow Items loaded to slideshow
@property (nonatomic, readonly, copy) NSArray<ImageSlideshowItem *> * _Nonnull slideshowItems;
/// Enables/disables infinite scrolling between images
@property (nonatomic) BOOL circular;
/// Enables/disables user interactions
@property (nonatomic) BOOL draggingEnabled;
/// Enables/disables zoom
@property (nonatomic) BOOL zoomEnabled;
/// Image change interval, zero stops the auto-scrolling
@property (nonatomic) double slideshowInterval;
/// Content mode of each image in the slideshow
@property (nonatomic) UIViewContentMode contentScaleMode;
/// Transitioning delegate to manage the transition to full screen controller
@property (nonatomic, readonly, strong) ZoomAnimatedTransitioningDelegate * _Nullable slideshowTransitioningDelegate;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)removeFromSuperview;
- (void)layoutSubviews;
- (void)layoutPageControl;
/// Set image inputs into the image slideshow
/// \param inputs Array of InputSource instances.
///
- (void)setImageInputs:(NSArray<id <InputSource>> * _Nonnull)inputs;
/// Change the current page
/// \param newPage new page
///
/// \param animated true if animate the change
///
- (void)setCurrentPage:(NSInteger)newPage animated:(BOOL)animated;
/// Change the scroll view page. This may differ from <code>setCurrentPage</code> as circular slider has two more dummy pages at indexes 0 and n-1 to provide fluent scrolling between first and last item.
/// \param newScrollViewPage new scroll view page
///
/// \param animated true if animate the change
///
- (void)setScrollViewPage:(NSInteger)newScrollViewPage animated:(BOOL)animated;
/// Stops slideshow timer
- (void)pauseTimer;
/// Restarts slideshow timer
- (void)unpauseTimer;
- (void)pauseTimerIfNeeded SWIFT_DEPRECATED_MSG("use pauseTimer instead");
- (void)unpauseTimerIfNeeded SWIFT_DEPRECATED_MSG("use unpauseTimer instead");
/// Open full screen slideshow
/// \param controller Controller to present the full screen controller from
///
///
/// returns:
/// FullScreenSlideshowViewController instance
- (FullScreenSlideshowViewController * _Nonnull)presentFullScreenControllerFrom:(UIViewController * _Nonnull)controller;
@end


@interface ImageSlideshow (SWIFT_EXTENSION(ImageSlideshow)) <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView * _Nonnull)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView * _Nonnull)scrollView;
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
@end

@class UITapGestureRecognizer;

/// Used to wrap a single slideshow item and allow zooming on it
SWIFT_CLASS("_TtC14ImageSlideshow18ImageSlideshowItem")
@interface ImageSlideshowItem : UIScrollView <UIScrollViewDelegate>
/// Image view to hold the image
@property (nonatomic, readonly, strong) UIImageView * _Nonnull imageView;
/// Input Source for the item
@property (nonatomic, readonly, strong) id <InputSource> _Nonnull image;
/// Guesture recognizer to detect double tap to zoom
@property (nonatomic, strong) UITapGestureRecognizer * _Nullable gestureRecognizer;
/// Holds if the zoom feature is enabled
@property (nonatomic, readonly) BOOL zoomEnabled;
/// If set to true image is initially zoomed in
@property (nonatomic) BOOL zoomInInitially;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)layoutSubviews;
- (void)scrollViewDidZoom:(UIScrollView * _Nonnull)scrollView;
- (UIView * _Nullable)viewForZoomingInScrollView:(UIScrollView * _Nonnull)scrollView SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
@end


/// Input Source to load plain UIImage
SWIFT_CLASS("_TtC14ImageSlideshow11ImageSource")
@interface ImageSource : NSObject <InputSource>
/// Initializes a new Image Source with UIImage
/// \param image Image to be loaded
///
- (nonnull instancetype)initWithImage:(UIImage * _Nonnull)image OBJC_DESIGNATED_INITIALIZER;
/// Initializes a new Image Source with an image name from the main bundle
/// \param imageString name of the file in the application’s main bundle
///
- (nullable instancetype)initWithImageString:(NSString * _Nonnull)imageString OBJC_DESIGNATED_INITIALIZER;
- (void)loadTo:(UIImageView * _Nonnull)imageView with:(void (^ _Nonnull)(UIImage * _Nullable))callback;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end



/// Input Source to image using Kingfisher
SWIFT_CLASS("_TtC14ImageSlideshow16KingfisherSource")
@interface KingfisherSource : NSObject <InputSource>
/// url to load
@property (nonatomic, copy) NSURL * _Nonnull url;
/// placeholder used before image is loaded
@property (nonatomic, strong) UIImage * _Nullable placeholder;
/// Initializes a new source with a URL
/// \param url a url to be loaded
///
/// \param placeholder a placeholder used before image is loaded
///
- (nonnull instancetype)initWithUrl:(NSURL * _Nonnull)url placeholder:(UIImage * _Nullable)placeholder OBJC_DESIGNATED_INITIALIZER;
/// Initializes a new source with a URL string
/// \param urlString a string url to load
///
/// \param placeholder a placeholder used before image is loaded
///
- (nullable instancetype)initWithUrlString:(NSString * _Nonnull)urlString placeholder:(UIImage * _Nullable)placeholder OBJC_DESIGNATED_INITIALIZER;
- (void)loadTo:(UIImageView * _Nonnull)imageView with:(void (^ _Nonnull)(UIImage * _Nullable))callback;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// Input Source to image using SDWebImage
SWIFT_CLASS("_TtC14ImageSlideshow16SDWebImageSource")
@interface SDWebImageSource : NSObject <InputSource>
/// url to load
@property (nonatomic, copy) NSURL * _Nonnull url;
/// placeholder used before image is loaded
@property (nonatomic, strong) UIImage * _Nullable placeholder;
/// Initializes a new source with a URL
/// \param url a url to be loaded
///
/// \param placeholder a placeholder used before image is loaded
///
- (nonnull instancetype)initWithUrl:(NSURL * _Nonnull)url placeholder:(UIImage * _Nullable)placeholder OBJC_DESIGNATED_INITIALIZER;
/// Initializes a new source with a URL string
/// \param urlString a string url to load
///
/// \param placeholder a placeholder used before image is loaded
///
- (nullable instancetype)initWithUrlString:(NSString * _Nonnull)urlString placeholder:(UIImage * _Nullable)placeholder OBJC_DESIGNATED_INITIALIZER;
- (void)loadTo:(UIImageView * _Nonnull)imageView with:(void (^ _Nonnull)(UIImage * _Nullable))callback;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


@interface UIActivityIndicatorView (SWIFT_EXTENSION(ImageSlideshow))
@property (nonatomic, readonly, strong) UIView * _Nonnull view;
- (void)show;
- (void)hide;
@end


@interface UIImage (SWIFT_EXTENSION(ImageSlideshow))
@end


@interface UIImageView (SWIFT_EXTENSION(ImageSlideshow))
@end

@protocol UIViewControllerAnimatedTransitioning;
@protocol UIViewControllerInteractiveTransitioning;

SWIFT_CLASS("_TtC14ImageSlideshow33ZoomAnimatedTransitioningDelegate")
@interface ZoomAnimatedTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>
/// parent image view used for animated transition
@property (nonatomic, strong) UIImageView * _Nullable referenceImageView;
/// parent slideshow view used for animated transition
@property (nonatomic, strong) ImageSlideshow * _Nullable referenceSlideshowView;
/// Enables or disables swipe-to-dismiss interactive transition
@property (nonatomic) BOOL slideToDismissEnabled;
/// Init the transitioning delegate with a source ImageSlideshow
/// \param slideshowView ImageSlideshow instance to animate the transition from
///
/// \param slideshowController FullScreenViewController instance to animate the transition to
///
- (nonnull instancetype)initWithSlideshowView:(ImageSlideshow * _Nonnull)slideshowView slideshowController:(FullScreenSlideshowViewController * _Nonnull)slideshowController OBJC_DESIGNATED_INITIALIZER;
/// Init the transitioning delegate with a source ImageView
/// \param imageView UIImageView instance to animate the transition from
///
/// \param slideshowController FullScreenViewController instance to animate the transition to
///
- (nonnull instancetype)initWithImageView:(UIImageView * _Nonnull)imageView slideshowController:(FullScreenSlideshowViewController * _Nonnull)slideshowController OBJC_DESIGNATED_INITIALIZER;
- (id <UIViewControllerAnimatedTransitioning> _Nullable)animationControllerForPresentedController:(UIViewController * _Nonnull)presented presentingController:(UIViewController * _Nonnull)presenting sourceController:(UIViewController * _Nonnull)source SWIFT_WARN_UNUSED_RESULT;
- (id <UIViewControllerAnimatedTransitioning> _Nullable)animationControllerForDismissedController:(UIViewController * _Nonnull)dismissed SWIFT_WARN_UNUSED_RESULT;
- (id <UIViewControllerInteractiveTransitioning> _Nullable)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning> _Nonnull)animator SWIFT_WARN_UNUSED_RESULT;
- (id <UIViewControllerInteractiveTransitioning> _Nullable)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning> _Nonnull)animator SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class UIGestureRecognizer;

@interface ZoomAnimatedTransitioningDelegate (SWIFT_EXTENSION(ImageSlideshow)) <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer * _Nonnull)gestureRecognizer SWIFT_WARN_UNUSED_RESULT;
@end

#pragma clang diagnostic pop
