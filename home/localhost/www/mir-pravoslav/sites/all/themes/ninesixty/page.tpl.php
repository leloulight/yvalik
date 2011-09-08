<?php
// $Id: page.tpl.php,v 1.1.2.1 2009/02/24 15:34:45 dvessel Exp $
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<?php print $language->language ?>" lang="<?php print $language->language ?>" dir="<?php print $language->dir ?>">

<head>
  <?php if (drupal_is_front_page()) : ?>
  	<title> <?php echo "Світ православія"; ?> </title>
  <?php else: ?>
  	<title><?php print $head_title; ?></title>	
  <?php endif; ?>
  
  <?php print $head; ?>
  <?php print $styles; ?>
  <?php print $scripts; ?>
  <?php if (drupal_is_front_page()) : ?>
  	<script type="text/javascript" src="<?php global $base_url ?><?= $base_url."/".path_to_theme() ?>/js/jquery.min.js" ></script>
  <?php endif; ?>
    <script type="text/javascript" src="<?= $base_url."/".path_to_theme() ?>/js/jquery.jcarousel.js" ></script>
    <link rel="stylesheet" type="text/css" href="<?= $base_url."/".path_to_theme() ?>/styles/skin.css" />
</head>

<body class="<?php print $body_classes; ?> show-grid">
  <div id="page" class="container-16 clear-block">

    <div id="site-header" class="clear-block">
      <div id="branding" class="grid-16 clear-block">
      <?php if ($linked_logo_img): ?>
        <span id="logo" class="grid-5 alpha"><?php print $linked_logo_img; ?></span>
      <?php endif; ?>
      <?php if ($linked_site_name): ?>
        <h1 id="site-name" class="grid-3 omega"><?php print $linked_site_name; ?></h1>
      <?php endif; ?>
      <?php if ($site_slogan): ?>
        <div id="site-slogan" class="grid-5 omega prefix-6"><?php print $site_slogan; ?></div>
      <?php endif; ?>
      </div>

    <?php if ($main_menu_links || $secondary_menu_links): ?>
      <div id="site-menu" class="grid-16">
        <?php print $main_menu_links; ?>
        <?php print $secondary_menu_links; ?>
      </div>
    <?php endif; ?>

    <?php if ($search_box): ?>
      <div id="search-box" class="grid-6 prefix-10"><?php print $search_box; ?></div>
    <?php endif; ?>
    </div>


    <div id="site-subheader" class="prefix-1 suffix-1 clear-block">
    <?php if ($mission): ?>
      <div id="mission" class="<?php print ns('grid-14', $header, 7); ?>">
        <?php print $mission; ?>
      </div>
    <?php endif; ?>

    <?php if ($header): ?>
      <div id="header-region" class="region <?php print ns('grid-14', $mission, 7); ?> clear-block">
        <?php print $header; ?>
      </div>
    <?php endif; ?>
    </div>
	
	<div id="bg-content" class="grid-16 clear-block">
	<div id="main" class="column <?php print 'grid-8 push-4' ?>">	
    <!--<div id="main" class="column <?php print ns('grid-16', $left, 4, $right, 3) . ' ' . ns('push-4', !$left, 4); ?>">-->
	  
	  <?php if ($ukr_prav): ?>
  			<div id="ukr_prav" class="region grid-4 column alpha ">
    			<?php print $ukr_prav ?>
  			</div>
	  <?php endif; ?>
	  <?php if ($world_prav): ?>
  			<div id="world_prav" class="region grid-4 column alpha  ">
    			<?php print $world_prav ?>
  			</div>
	  <?php endif; ?>
      <?php print $breadcrumb; ?>
      <?php if ($title): ?>
        <h1 class="title" id="page-title"><?php print $title; ?></h1>
      <?php endif; ?>
      <?php if ($tabs): ?>
        <div class="tabs"><?php print $tabs; ?></div>
      <?php endif; ?>
      <?php print $messages; ?>
      <?php print $help; ?>

      <div id="main-content" class="region clear-block">
        <?php print $content; ?>
      </div>

      <?php print $feed_icons; ?>
    </div>

		
  <?php if ($left || $new_program): ?>
    <div id="sidebar-left" class="column sidebar region grid-4  pull-8 ">
		<?php if ($new_program): ?>
  			<div id="new_program" class="region">
    			<?php print $new_program ?>
  			</div>
		<?php endif; ?>
      <?php print $left; ?>
    </div>
  <?php endif; ?>

  <?php if ($right || $slovopredst): ?>
    <div id="sidebar-right" class="column sidebar region ">
		<?php if ($slovopredst): ?>
  			<div id="slovopredst" class="region">
    			<?php print $slovopredst ?>
  			</div>
	  	<?php endif; ?>
      <?php print $right; ?>
    </div>
  <?php endif; ?>
	

  <div id="footer" class="prefix-1 suffix-1">
    <?php if ($footer): ?>
      <div id="footer-region" class="region grid-14 clear-block">
        <?php print $footer; ?>
      </div>
    <?php endif; ?>

    <?php if ($footer_message): ?>
      <div id="footer-message" class="grid-14">
        <?php print $footer_message; ?>
      </div>
    <?php endif; ?>
  </div>

</div>

  </div>
  <?php print $closure; ?>
</body>
 <script>
  	
    jQuery(document).ready(function() {
    jQuery('#block-views-new_vipusk-block_1 .view-content ul').attr('id','mycarousel');
	jQuery('#block-views-new_vipusk-block_1 .view-content ul').attr('class','jcarousel jcarousel-skin-tango');
	
	jQuery('#mycarousel').jcarousel({
        vertical: true,
        scroll: 2
    });
});
  </script>
</html>
